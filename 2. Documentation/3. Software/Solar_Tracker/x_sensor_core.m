function varargout = x_sensor_core(action, varargin)
%X_SENSOR_CORE Physical (simplified) sun-sensor/actuator digital-twin engine.
% Coordinates: +x East, +y North, +z up; azimuth clockwise from North.
% This module is independent of GUI. No toolbox required.
%
% cfg   = x_sensor_core('config');
% state = x_sensor_core('init', cfg);
% state = x_sensor_core('step', state, cfg, azDeg, elevDeg, dtSeconds);
% sense = x_sensor_core('sense', anglesRadians, azDeg, elevDeg, cfg);
% th    = x_sensor_core('fromlengths', Lmeters, guessRadians, cfg);
% L     = x_sensor_core('lengths', thRadians, cfg);
%
% Safety: mechanical yaw, linkages, wind, force, physical sensing,
% backdriving and electrical drivers are not verified in this demo.

switch lower(action)
    case 'config'
        cfg = tracker_config();
        cfg.sensorBoardWidth = 0.120;   % m, X walls match 44:72 aspect
        cfg.sensorWallHalfLength = 0.115; % m along each diagonal
        cfg.sensorWallHeight = 0.100;    % m raised vertical shading walls
        cfg.sensorRadius = 0.006;        % m sensor active circle radius
        cfg.sensorNorthOffset = 0.015;   % m from cross center
        cfg.sensorEastOffset = cfg.sensorNorthOffset * cfg.panelEW / cfg.panelNS;
        cfg.sensorGrid = 9;              % samples per dimension across disk
        cfg.sensorDNI = 850;             % hypothetical beam irradiance, W/m2
        cfg.sensorDiffuse = 90;          % hypothetical diffuse irradiance
        cfg.sensorGain = ones(4,1);      % calibration N,E,S,W
        cfg.sensorErrorDeadband = 0.025;
        cfg.controllerGainDeg = 2.0;     % angle nudge per normalized error
        cfg.demoDtSeconds = 0.20;
        cfg.sensorLowLight = 100;
        cfg.maxPitchDeg = 10;
        cfg.maxRollDeg = 10;
        varargout{1} = cfg;
    case 'init'
        cfg = varargin{1};
        st.t = 0;
        st.angles = [0;0];             % north-edge-up, west-edge-up radians
        st.lengths = lengths(st.angles,cfg);
        st.targetAngles = st.angles;
        st.targetLengths = st.lengths;
        st.sensor = sense(st.angles,315,82,cfg);
        st.commands = [0;0];          % -1 retract, 0 stop, +1 extend
        st.mode = 'Ready';
        st.minCornerM = cornerClearance(st.angles,cfg);
        st.pointingErrorDeg = NaN;
        st.totalMotorSeconds = [0;0];
        st.hist.t = 0;
        st.hist.errorNS = st.sensor.error(1);
        st.hist.errorEW = st.sensor.error(2);
        st.hist.pitch = 0;
        st.hist.roll = 0;
        st.hist.align = NaN;
        st.hist.N = st.sensor.raw(1);
        st.hist.E = st.sensor.raw(2);
        st.hist.S = st.sensor.raw(3);
        st.hist.W = st.sensor.raw(4);
        st.hist.northLengthIn = st.lengths(1)/0.0254;
        st.hist.westLengthIn = st.lengths(2)/0.0254;
        st.hist.sunAzDeg = NaN;
        st.hist.sunElevDeg = NaN;
        varargout{1} = st;
    case 'step'
        varargout{1} = step(varargin{:});
    case 'sense'
        varargout{1} = sense(varargin{:});
    case 'lengths'
        varargout{1} = lengths(varargin{:});
    case 'fromlengths'
        [varargout{1}, varargout{2}] = fromLengths(varargin{:});
    case 'rotation'
        varargout{1} = rotation(varargin{1});
    case 'sunvec'
        varargout{1} = sunVector(varargin{1}, varargin{2});
    case 'clearance'
        varargout{1} = cornerClearance(varargin{:});
    case 'safe'
        varargout{1} = safePose(varargin{:});
    case 'steer' % returns desired tilt using SENSOR READINGS only
        varargout{1} = steer(varargin{:});
    otherwise
        error('Unknown x_sensor_core action: %s',action);
end
end

function st = step(st,cfg,az,elev,dt)
% Sun inputs appear ONLY in simulated measurement and evaluation.
% steer() never receives sun azimuth/elevation or the true sun vector.
if ~isscalar(dt) || ~isfinite(dt) || dt<=0
    error('Simulation dt must be a positive finite number.');
end
st.sensor = sense(st.angles,az,elev,cfg);
[desired, mode] = steer(st.sensor, st.angles, cfg);
% Enforce maximum tilt / actuator envelope / lower-frame clearance.
desired = projectSafe(st.angles,desired,cfg);
st.targetAngles = desired;
st.targetLengths = lengths(desired,cfg);
maxMove = cfg.actSpeed*dt;  % meters travelled in each independent actuator
old = st.lengths;
new = old + max(-maxMove,min(maxMove,st.targetLengths-old));
new = max(cfg.actMinLength,min(cfg.actMaxLength,new));
% Two actuator positions -> two tilts; yaw must be physically constrained.
[th,residual] = fromLengths(new,st.angles,cfg);
if residual > 1e-6 || ~safePose(th,cfg)
    % Avoid moving outside the assumed kinematic limits, including corners.
    low=0; high=1; newOK=old; thetaOK=st.angles;
    for i=1:22
        a=(low+high)/2;
        try
            candidateL=old+a*(new-old);
            [candidateTh,res]=fromLengths(candidateL,st.angles,cfg);
            works=res<=1e-6 && safePose(candidateTh,cfg);
        catch
            works=false;
        end
        if works
            low=a; newOK=candidateL; thetaOK=candidateTh;
        else
            high=a;
        end
    end
    new=newOK; th=thetaOK;
end
movement=new-old;
st.commands = sign(movement);
st.totalMotorSeconds = st.totalMotorSeconds + abs(movement)./max(cfg.actSpeed,eps);
st.lengths = new;
st.angles = th;
st.t = st.t + dt;
st.sensor = sense(st.angles,az,elev,cfg);
st.minCornerM=cornerClearance(st.angles,cfg);
normal=rotation(st.angles)*[0;0;1];
sun=sunVector(az,elev);
st.pointingErrorDeg = acosd(max(-1,min(1,dot(normal,sun))));
if strcmp(mode,'Tracking') && norm(movement)<1e-9
    st.mode='Motion limited (joint/tilt/stroke/clearance)';
else
    st.mode=mode;
end
st.hist.t(end+1,1)=st.t;
st.hist.errorNS(end+1,1)=st.sensor.error(1);
st.hist.errorEW(end+1,1)=st.sensor.error(2);
st.hist.pitch(end+1,1)=rad2deg(st.angles(1));
st.hist.roll(end+1,1)=rad2deg(st.angles(2));
st.hist.align(end+1,1)=st.pointingErrorDeg;
st.hist.N(end+1,1)=st.sensor.raw(1);
st.hist.E(end+1,1)=st.sensor.raw(2);
st.hist.S(end+1,1)=st.sensor.raw(3);
st.hist.W(end+1,1)=st.sensor.raw(4);
st.hist.northLengthIn(end+1,1)=st.lengths(1)/0.0254;
st.hist.westLengthIn(end+1,1)=st.lengths(2)/0.0254;
st.hist.sunAzDeg(end+1,1)=az;
st.hist.sunElevDeg(end+1,1)=elev;
end

function [desired, mode] = steer(m,theta,cfg)
% NOTE: This IS the feedback controller. No sun-position information.
% m.raw = [N,E,S,W]; errors = [(N-S)/(N+S), (W-E)/(W+E)].
desired = theta;
if mean(m.raw)<cfg.sensorLowLight
    mode='Low light: stopped'; return;
end
e=m.error;
if all(abs(e)<cfg.sensorErrorDeadband)
    mode='Sensor balanced (inside deadband)'; return;
end
% +e_NS = brighter NORTH -> point toward north -> lower N edge (negative Rx)
% +e_EW = brighter WEST  -> point toward west  -> lower W edge (negative Ry)
e(abs(e)<cfg.sensorErrorDeadband)=0;
desired=theta - deg2rad(cfg.controllerGainDeg)*e;
mode='Tracking using sensor errors';
end

function projected = projectSafe(current,candidate,cfg)
if safePose(candidate,cfg)
    projected=candidate; return;
end
low=0; high=1;
for k=1:28
    q=(low+high)/2;
    theta=current+q*(candidate-current);
    if safePose(theta,cfg), low=q; else, high=q; end
end
projected=current+low*(candidate-current);
end

function sensor = sense(theta,az,elev,cfg)
% Geometric ray-shadow calculation on 4 circular photosensor patches.
% The two thin vertical X walls follow PANEL DIAGONALS (44:72).
% Each patch is discretized; partial shadow is the blocked ray fraction.
s=sunVector(az,elev);
sLocal=rotation(theta)'*s;
centers=[0, cfg.sensorEastOffset,0,-cfg.sensorEastOffset; ...
         cfg.sensorNorthOffset,0,-cfg.sensorNorthOffset,0];
N=cfg.sensorGrid;
coords=linspace(-1,1,N);
[cx,cy]=meshgrid(coords,coords);
valid=(cx.^2+cy.^2)<=1;
dx=cx(valid)*cfg.sensorRadius;
dy=cy(valid)*cfg.sensorRadius;
% 4 sectors; 2 diagonal wall orientations. Both walls are finite length.
u1=[cfg.panelEW/2;cfg.panelNS/2]; u1=u1/norm(u1);
u2=[-cfg.panelEW/2;cfg.panelNS/2]; u2=u2/norm(u2);
wall=[u1,u2];
sensor.raw=zeros(4,1);
sensor.visibility=zeros(4,1);
beam=cfg.sensorDNI*max(0,sLocal(3));
for j=1:4
    points=centers(:,j)+[dx.';dy.'];
    blocked=false(1,size(points,2));
    if sLocal(3)>1e-6
        for w=1:2
            u=wall(:,w); normal=[-u(2);u(1)];
            denom=dot(normal,sLocal(1:2));
            if abs(denom)<1e-10, continue; end
            t=-(normal.'*points)/denom;
            crossed=t>1e-8 & t*sLocal(3)<cfg.sensorWallHeight;
            along=u.'*points+t*(u.'*sLocal(1:2));
            crossed=crossed & abs(along)<=cfg.sensorWallHalfLength;
            blocked=blocked | crossed;
        end
    end
    sensor.visibility(j)=1-mean(blocked);
    sensor.raw(j)=cfg.sensorGain(j)*(cfg.sensorDiffuse + beam*sensor.visibility(j));
end
% Normalization protects against source-intensity changes.
Nval=sensor.raw(1); Eval=sensor.raw(2);
Sval=sensor.raw(3); Wval=sensor.raw(4);
sensor.error=[(Nval-Sval)/max(1,Nval+Sval); ...
              (Wval-Eval)/max(1,Wval+Eval)];
sensor.localSun=sLocal;
end

function R = rotation(th)
% Same convention as v1.2 original code:
% pitch>0 lifts north edge; roll>0 lifts west edge.
p=th(1); r=th(2);
cp=cos(p); sp=sin(p); cr=cos(r); sr=sin(r);
R=[cr,sr*sp,sr*cp; 0,cp,-sp; -sr,cr*sp,cr*cp];
end

function s = sunVector(az,elev)
% Compass azimuth 0=N,90=E,180=S,270=W; elevation 90=zenith.
a=deg2rad(az); e=deg2rad(elev);
s=[sin(a)*cos(e); cos(a)*cos(e); sin(e)];
end

function L = lengths(theta,cfg)
R=rotation(theta);
L=zeros(2,1);
for i=1:2
    L(i)=norm(cfg.pivot+R*cfg.upperMounts(:,i)-cfg.lowerMounts(:,i));
end
end

function [th,res] = fromLengths(L,initial,cfg)
% Newton inversion, following the near-level branch.
th=initial;
for k=1:32
    errorL=L-lengths(th,cfg);
    if norm(errorL)<5e-9, break; end
    J=zeros(2,2); epsilon=1e-5;
    for i=1:2
        dp=zeros(2,1);dp(i)=epsilon;
        J(:,i)=(lengths(th+dp,cfg)-lengths(th-dp,cfg))/(2*epsilon);
    end
    if rcond(J)<1e-10
        error('Mount kinematics near singular; validate attachment coordinates.');
    end
    stepAngle=J\errorL;
    stepAngle=max(-deg2rad(4),min(deg2rad(4),stepAngle));
    th=th+stepAngle;
end
res=norm(L-lengths(th,cfg));
end

function z = cornerClearance(th,cfg)
R=rotation(th);
x=cfg.panelEW/2; y=cfg.panelNS/2;
xy=[-x,x,x,-x;-y,-y,y,y];
corner=cfg.pivot+R*[xy;ones(1,4)*cfg.upperPlaneOffset];
z=min(corner(3,:));
end

function yes = safePose(theta,cfg)
if any(~isfinite(theta)) || ...
   abs(theta(1)) > deg2rad(cfg.maxPitchDeg)+1e-9 || ...
   abs(theta(2)) > deg2rad(cfg.maxRollDeg)+1e-9
    yes=false;return;
end
L=lengths(theta,cfg);
yes=all(L>=cfg.actMinLength-1e-8) && ...
    all(L<=cfg.actMaxLength+1e-8) && ...
    cornerClearance(theta,cfg)>=cfg.minPanelHeight-1e-8;
end
