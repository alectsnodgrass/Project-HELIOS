function verify_x_sensor_tracker()
%VERIFY_X_SENSOR_TRACKER Run controlled scenarios WITHOUT opening the GUI.
% Uses same sensor rays, feedback controller and moving-actuator kinematics.
% This is numerical model verification, NOT physical hardware certification.

cfg=x_sensor_core('config');
ref=x_sensor_core('init',cfg);
assert(x_sensor_core('safe',ref.angles,cfg),'Initial pose unsafe');
assert(all(abs(ref.lengths/.0254 - sqrt(12^2+18^2))<1e-6), ...
    'Incorrect neutral geometry or actuator length.');
vertical=x_sensor_core('sense',[0;0],0,90,cfg);
assert(max(abs(vertical.error))<1e-10, ...
    'Perfectly overhead sun should balance all four sensors.');

g=x_sensor_core('sense',[0;0],315,82,cfg);
assert(g.error(1)>0 && g.error(2)>0, ...
    'Northwest sun should make the north and west readings larger.');

scenarios=[315 82;45 82;90 82;180 82;0 90];
for c=1:size(scenarios,1)
    az=scenarios(c,1);el=scenarios(c,2);
    state=x_sensor_core('init',cfg);
    normSun=x_sensor_core('sunvec',az,el);
    n0=x_sensor_core('rotation',state.angles)*[0;0;1];
    initialError=acosd(max(-1,min(1,dot(normSun,n0))));
    maxDuration=80;dt=cfg.demoDtSeconds;
    for j=1:round(maxDuration/dt)
        old=state;
        state=x_sensor_core('step',state,cfg,az,el,dt);
        assert(x_sensor_core('safe',state.angles,cfg), ...
            'Unsafe pose at scenario %d iteration %d',c,j);
        assert(all(abs(state.lengths-old.lengths)<=cfg.actSpeed*dt+1e-7), ...
            'Actuator motion too fast.');
        assert(state.minCornerM>=cfg.minPanelHeight-1e-7, ...
            'Panel struck lower frame.');
        assert(all(state.lengths>=cfg.actMinLength-1e-7) && ...
               all(state.lengths<=cfg.actMaxLength+1e-7), ...
            'Actuator stroke limit exceeded.');
    end
    finalError=state.pointingErrorDeg;
    fprintf('Sun %3.0f az / %2.0f el: pointing %.2f --> %.2f deg | ', ...
        az,el,initialError,finalError);
    fprintf('pitch %+.2f, roll %+.2f deg\n',rad2deg(state.angles));
    if initialError>0.1
        assert(finalError<initialError-1, ...
            'Sensor-based tracking did not appreciably improve pointing.');
        assert(finalError<4.5, ...
            'Sensor-based pointing error too large for a high-elevation test.');
    else
        assert(norm(state.angles)<1e-8, ...
            'Overhead light should keep the panel level.');
    end
end
fprintf('\nAll sensor, convergence and actuator-envelope checks passed.\n');
fprintf(['These tests do NOT validate real wind loads, elbow joints, ', ...
    'motor force, sensor calibration, or hardware feedback.\n']);
end
