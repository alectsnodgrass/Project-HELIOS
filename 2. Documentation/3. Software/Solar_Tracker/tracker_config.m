function cfg = tracker_config()
%TRACKER_CONFIG  EDIT THESE INPUTS TO MATCH THE ACTUAL CAPSTONE HARDWARE.
% Coordinate system attached to the lower frame: x=East, y=North, z=Up.
% Lengths in meters; angles in radians; power in watts.
%
% IMPORTANT: Actuator model/ratings below are from the selected Firgelli unit.
% Mount coordinates, loaded speed, actual current and PV inputs remain
% ILLUSTRATIVE and MUST be verified before physical hardware operation.

% Panel / frame design assumption: 44 in East-West by 72 in North-South.
% Swap these values if the long edge actually runs East-West. Geometry must
% be replaced with measured frame dimensions before hardware sign-off.
cfg.panelEW = 44 * 0.0254;
cfg.panelNS = 72 * 0.0254;
cfg.panelArea = cfg.panelEW * cfg.panelNS;
cfg.panelEfficiency = 0.205;       % illustrative, NOT measured

% Z = 0: bottom frame plane.  Z = 12 in: upper frame plane (when level).
% Ball-joint center sits halfway: 6 in above base, 6 in below top frame.
cfg.frameSeparation = 12 * 0.0254;
cfg.upperPlaneOffset = 6 * 0.0254;  % upper-frame Z relative to pivot
cfg.pivot = [0; 0; 6 * 0.0254];

% Design proposal: attach BOTH actuator base ends ON the lower-frame rims.
% Upper ends also mount to the north/west RIMS of the top frame.
% Coordinate x=East, y=North, z=Up (all in meters). Columns: North, West.
% The actuatOR upperMounts are LOCAL TO THE CENTRAL BALL JOINT.
%               NORTH                  WEST
% Lower:  (-18, +36, 0) in     (-22, -18, 0) in
% Upper:  (  0, +36,+12) in    (-22,   0,+12) in WHEN LEVEL.
% This 18-in lateral STAGGER on each rim is NOT specified by the user:
% it is a provisional choice that allows the 16.5-in minimum-length
% actuators to fit into a 12-in vertical gap.
% IMPORTANT: The physical actuators and brackets MAY COLLIDE with the frame
% or PV underside; verify 3D envelope, angular misalignment, loads, and
% exact joint center-to-center lengths in CAD and on actual hardware.
in = 0.0254;
cfg.lowerMounts = in * [-18, -22;
                         +36, -18;
                          0,   0];
cfg.upperMounts = in * [  0, -22;
                         +36,   0;
                          +6,  +6];
cfg.mountStaggerIn = 18;
% Actual hardware: Firgelli C-Series FA-C-135-12-12 (both axes).
% Sources: https://www.firgelliauto.com/products/c-series-actuators?variant=41434276954183
cfg.actuatorModel = 'FA-C-135-12-12';
cfg.actVoltageV = 12;                    % actual rated supply voltage
cfg.actRatedForceN = 135 * 4.448221615; % 135 lbf axial force (not validated load)
cfg.actStrokeM = 12 * 0.0254;           % actual rated stroke, 304.8 mm
cfg.actMinLength = [16.5;16.5] * 0.0254; % rated retracted length
cfg.actMaxLength = [28.5;28.5] * 0.0254; % rated extended length
cfg.actNoLoadSpeedMps = 0.6 * 0.0254;  % rated no-load speed, 15.24 mm/s
cfg.actMaxCurrentA = 4.2;              % datasheet maximum draw PER unit
cfg.actDutyFractionFullLoad = 0.25;    % 25%% at full load (window unspecified)
cfg.actLoadSpeedFactor = 0.50;         % ASSUMED; loaded speed not known yet
cfg.actSpeed = repmat(cfg.actNoLoadSpeedMps * cfg.actLoadSpeedFactor,2,1);
cfg.actRunPower = repmat(cfg.actVoltageV * cfg.actMaxCurrentA,2,1);
% Power uses nameplate maximum current as a conservative operating budget;
% it is NOT a measured or load-calibrated draw. Starting/stall surges unknown.
% The chosen actuators have NO position feedback. This MATLAB twin uses an
% IDEAL VIRTUAL POSITION SENSOR; real deployment needs external position
% sensing (or a validated observer with homing/calibration) and fault stops.
cfg.idealVirtualPositionSensor = true;
% Manufacturer warns about back-driving without power: holding safety not
% simulated here; verify need for external brake/lock before real-world use.

cfg.maxPitchDeg = 10;             % initial controller tilt limit, NOT measured
cfg.maxRollDeg = 10;
cfg.minPanelHeight = 0.05;        % illustrative 50 mm clearance above lower plane

cfg.latitudeDeg = 36.2;            % ILLUSTRATIVE latitude; adjust for location
cfg.dayOfYear = 172;               % illustrative June day
cfg.startSolarHour = 8;
cfg.endSolarHour = 17;
cfg.samplePeriodSec = 45;
cfg.probeStepDeg = 2;              % power-search command increment
cfg.probeThresholdW = 0.35;        % minimum power increase to accept trial
cfg.measureNoiseStdW = 0;         % start noise-free; increase in stress tests

% Simplified hypothetical clear-day weather, NOT historic observed weather.
cfg.peakDNI = 850;                 % W/m^2 direct-normal irradiance
cfg.peakDHI = 120;                 % W/m^2 diffuse-horizontal irradiance
cfg.albedo = 0.20;
cfg.cloudStartSolarHour = 12.25;
cfg.cloudEndSolarHour = 13.00;
cfg.cloudFactor = 1.0;            % 1 = clear day; try 0.35 for cloud event
end
