# X-shaped four-sensor solar tracking


## Sun input range
The sun-position slider and typed elevation are restricted to **60–90° above the horizon**. This means the simulated sun may be at most **30° away from directly overhead in any compass direction**. Azimuth still runs from 0–360°. The last two presets test the maximum 30° offset at 60° elevation. The limit applies to the **sun input only**, not the mechanical motion of the upper frame.

**Important:** The physical twin still limits pitch and roll to approximately ±10° plus actuator stroke and clearance constraints. As a result, it **will not track** a sun positioned 30° away from zenith; it will stop at the permitted mechanical configuration. For a demonstration that reaches its target, use sun elevations near overhead (typically 80–90°, depending on azimuth). Changing the sun-input range does not justify loosening collision clearance.


## Quick start
1. Unzip this project into a folder.
2. In MATLAB, set **Current Folder** to the folder containing the `.m` files.
3. Type:

```matlab
x_sensor_tracker_demo
```

4. Set **Sun azimuth** (0° North, 90° East, 180° South, 270° West) and **elevation** (60–90° above the horizon) with the sliders or number boxes. Use a preset if preferred.
5. Press **RUN / RESUME**, **PAUSE**, **STEP**, or **RESET**. Press **EXPORT CSV** to save the complete trajectory, light readings, actuator lengths, and sun inputs for your report. **You can change the sun while the model is running.**
6. Watch the **3D panel** and two actuators, **four light-sensor signals**, and **north–south / west–east sensor errors**. Blue arrow = panel normal; gold arrow = true sun direction (display-only).
7. For numerical validation without opening an interface, run:

```matlab
verify_x_sensor_tracker
```


## What is actually being simulated
This is a **closed-loop, sensor-driven kinematic model**, NOT a scripted motion trajectory:

```
User sun azimuth/elevation
         |
         v
Physics model: sun ray intersects TWO vertical X-shaped walls
         |
         v
4 simulated photocells N / E / S / W (partly or fully shaded)
         |
         v
Controller only receives N / E / S / W readings, NOT sun angles
         |
         v
Compute two normalized errors: e_NS=(N-S)/(N+S), e_WE=(W-E)/(W+E)
         |
         v
Small desired pitch/roll correction with deadband
         |
         v
Compute BOTH actuator pin-to-pin lengths from 3D mount coordinates
         |
         v
Move Firgelli north / west actuators at rate-limited speed
         |
         v
Solve resulting panel orientation and check physical boundaries
         |
         +-------> Feed new panel angle back to simulated sunlight sensors
```

True sun position and *actual pointing error* are used by the **scene and sensor model only**; the controller does not use those data. This is important for validating the controller logic. `x_sensor_core.m` is organized to enforce that separation: `steer(measurement, pose, cfg)` has no azimuth or elevation argument.


## Updated capstone layout assumptions
- 44 × 72 in rectangular panel, long edge oriented North–South (edit in `tracker_config.m` if panel is oriented differently).
- Fixed lower frame, upper panel-carrying frame.
- Center ball joint 6 in above fixed frame and 6 in below upper frame. Upper frame is 12 in above lower frame when level.
- Two selected **Firgelli C-Series FA-C-135-12-12**, 12 V, 12 in stroke, 16.5–28.5 in joint-length *nominal* envelope, 0.6 in/s no-load speed. Simulation uses assumed **50% loaded speed**.
- Lower north actuator mounted on north rim at (-18,+36,0) in; upper north mount (0,+36,12) in when level.
- Lower west actuator mounted on west rim at (-22,-18,0) in; upper west mount (-22,0,12) in when level.
- The 18-in offset along each rim is an **illustrative design assumption**, needed to fit 16.5-in minimum actuator length in 12-in frame separation. Exact positions/clearances are **not confirmed**.
- Panel pitch and roll are each limited to ±10° by assumption; all four panel corners must remain at least 50 mm above lower-frame plane; actuator strokes and speeds are enforced.
- **Yaw is assumed constrained by a mechanically valid linkage; the proposed ball joint and elbow linkages have NOT been modeled or validated.**
- The chosen actuators have **no built-in position feedback**. This simulated plant has ideal virtual actuator position knowledge. The physical system will need external feedback and interlocks, or a separately validated approach.


## X sensor specifics
In `x_sensor_core.m`, `'config'` supplies the starting assumptions:

| Parameter | Value | Meaning |
|---|---|---|
| Shading walls | two vertical, perpendicular only if panel square; here diagonal | X follows the rectangular panel's 44:72 diagonal slopes |
| Wall height | 100 mm | Experimental, adjustable |
| Sensor center N/S | ±15 mm | Relative to X center |
| Sensor center E/W | ±9.17 mm | Scaled by width/length ratio |
| Sensor active patch radius | 6 mm | Sampled on a disk using a 9×9 grid |
| Beam/diffuse | 850/90 W/m² | Illustrative steady sunlight |
| Controller gain | 2° per unit of normalized error | Starting value only |
| Error deadband | 0.025 | Prevents constant jitter |
| Update timestep | 0.2 s | Simulated time per animation frame |

The model calculates where each sun ray would intersect the X walls and approximates the exposed fraction of each circular photocell. **This is not a measured sensor transfer function.** Diffuse light is represented by a constant baseline; the model does not yet include realistic scattering, wall thickness, manufacturing imperfections, thermal drift, reflections, clouds or sensor noise. With finite wall height and finite sensor size, balanced readings can occur even when the panel still has a small orientation error.

The X wall directions are parallel to the solar panel diagonals. 


## Validation and interpretation
`verify_x_sensor_tracker` checks five high-elevation test cases, including overhead sunlight, and verifies that sensor inputs drive a useful pointing correction, actuator speed and length limits are respected, and lower-frame clearance is maintained. Low-elevation input (e.g., 315° azimuth, 60° elevation) is intentionally largely **unreachable** within the ±10° tilt assumption. An inability to align fully in that case is the correct physical result, not an algorithm defect.

This demo can show sensor-driven convergence in a **simplified mathematical twin**. It cannot establish the mechanical feasibility of side elbow linkages, actuator force against winds, the security of the central ball joint, 12-V driver electronics, actuator backdriving/hold, or the outdoor performance of real sensors. A hardware control implementation should use current and position monitoring, limit switches, emergency stop, timeouts, and a stowed position for vehicle movement.


## Files
- **`x_sensor_tracker_demo.m`** — start here; full interactive MATLAB GUI and animated 3D frame.
- **`x_sensor_core.m`** — shared physical shadow model, controller, actuator kinematics, safety checks.
- **`verify_x_sensor_tracker.m`** — automated numerical checks using the same core.
- `tracker_config.m` — previous v1.2 mounting assumptions and Firgelli actuator data (used by new model).
- `legacy_v1_2/solar_tracker_twin.m`, `legacy_v1_2/verify_tracker_twin.m` — previous power-only P&O example; **not used by the X-sensor GUI**.
- `README.md` — this document.
