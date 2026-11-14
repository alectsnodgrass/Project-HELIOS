# Purpose

The purpose of this experiment was to establish baseline charging performance for the original Lani EV solar system before the team implements its solar-tracking design. Both systems can charge the golf cart while it is moving. The team’s design adds the ability to track the sun while the cart is parked. Voltage and current were measured between the MPPT controller and the battery, along with illuminance and battery percentage. The same measurements will be collected after the tracking system is installed to compare charging performance under similar conditions.

# Electrical Power Analysis

Voltage and current were measured between the MPPT charge controller and the golf cart battery. Battery-side charging power was calculated using P = VI. This represents power delivered from the controller toward the battery, rather than power measured directly at the solar panel. Table 1 shows the average and peak charging power for each test day, along with average estimated irradiance.

**Table 1. Average and Peak Charging Power for the Original Design**

| Test date    | Average power (W) | Peak power (W) | Avg. estimated irradiance (W/m²) |
|--------------|-------------------|----------------|----------------------------------|
| Oct. 9, 2026 | 145.32            | 202.37         | 330.9                            |
| Nov. 3, 2026 | 138.48            | 192.75         | 350.8                            |
| Nov. 7, 2026 | 181.99            | 205.35         | 402.7                            |
| Nov. 8, 2026 | 161.31            | 179.62         | 417.6                            |

Of the four test days, November 7 had the highest average power at 181.99 W and the highest single reading at 205.35 W. November 3 had the lowest average power at 138.48 W. Although November 8 had the highest average estimated irradiance, its average power was lower than November 7. This shows that the amount of sunlight was not the only factor affecting the readings. The panel angle, battery charging conditions, temperature, and changes in weather could also have influenced the results.

# Estimated Energy Production

Charging energy over each test period was estimated using the trapezoidal method, E ≈ Σ\[(Pᵢ + Pᵢ₊₁)/2\]Δt. This estimates the area under the power-versus-time curve. When time is expressed in hours, the resulting energy is in watt-hours (Wh).

**Table 2. Estimated Charging Energy for the Original Design**

| Test date | Recorded duration | Estimated energy (Wh) |
|-----------|-------------------|-----------------------|
| Oct. 9    | 4 h 35 min        | 681.9                 |
| Nov. 3    | 4 h 35 min        | 648.8                 |
| Nov. 7    | 4 h 35 min        | 851.7                 |
| Nov. 8    | 5 h               | 814.1                 |

November 7 had the highest estimated energy of the four tests at 851.7 Wh. November 3 had the lowest at 648.8 Wh. These values are estimates based on measurements taken at intervals, rather than continuous energy measurements. The November 8 test also lasted longer than the other three, so the energy totals should be compared with that difference in mind.

# Estimated Irradiance

An irradiance meter was not available for testing, so the team used an illuminance meter to record incoming light. Irradiance was estimated using G ≈ L/K, where L is illuminance in lux and K is the assumed luminous efficacy of daylight. A value of K = 122 lm/W was used throughout the calculations. Since illuminance measures visible light rather than total solar energy, the irradiance values are estimates. The measured voltage and current were used to calculate charging power delivered from the MPPT controller toward the battery.

# Expected Improvement from Solar Tracking

Both systems can charge the golf cart while it is moving. The team’s design also allows the panel to track the sun while the cart is parked. Adjusting the panel angle during parked periods is expected to improve charging, particularly in the morning and afternoon. Once the tracking system is installed, the team will repeat the measurements and compare charging power and energy against the original system under similar conditions.

# Limitations and Comparison Requirements

- Because an irradiance meter was unavailable, irradiance was estimated from illuminance using 122 lm/W. These values are not direct irradiance measurements.

- Measurements were taken about every 25 minutes. Changes in sunlight or power between readings may not appear in the data.

- Weather, panel temperature, solar angle, and the battery’s starting charge level were not necessarily identical across the test days.

- Voltage and current were measured between the MPPT controller and the battery, so the calculated power is battery-side charging power, not direct panel output.

- Testing of the tracking design should use the same instruments and measurement points, with test duration, time of day, and battery conditions kept as consistent as possible.

# Graphical Results — Original Design

Figures 1–4 show measurements from the original charging system collected on October 9 and November 3, 7, and 8, 2026. These results will serve as the baseline for comparison with the tracking design.

## Figure 1. Power throughout each test day

![Experimental analysis graph](media/image1.png)

Power changed throughout each test day. The curves also show that the measurements were taken over different time windows, so this graph is a baseline rather than a direct comparison with tracking.

## Figure 2. Average power by test date

![Experimental analysis graph](media/image2.png)

November 7 had the highest average power of the four test days. Differences between days may be related to both sunlight and charging conditions.

## Figure 3. Estimated energy by test date

![Experimental analysis graph](media/image3.png)

The energy totals were estimated from the power readings. November 8 had a longer test period than the other days, which should be considered when comparing totals.

## Figure 4. Battery percentage throughout testing

![Experimental analysis graph](media/image4.png)

The battery percentage readings show how the reported state of charge changed during testing. On October 9, the battery increased from 6% to 16%, a gain of 10 percentage points. On November 3, it increased from 17% to 24%, a gain of 7 percentage points. On November 7, it increased from 24% to 35%, a gain of 11 percentage points. On November 8, it increased from 34% to 46%, a gain of 12 percentage points. The starting battery percentages and test durations differed, so these changes should not be treated as direct measures of charging energy.

After installation, the team will repeat the measurements at the same battery-side locations and under similar conditions. Average charging power and estimated charging energy will then be compared over matching test periods, with particular attention to the tracking system’s performance while the cart is parked.

# Conclusion

The original Lani EV solar charging system produced average battery-side charging power ranging from 138.48 W to 181.99 W across the four testing days. The highest estimated charging energy was recorded on November 7 at 851.7 Wh. These results show how the original system performs under different sunlight and charging conditions and provide a baseline for evaluating the team’s solar-tracking design. Once the tracking system is implemented, the team will repeat the measurements under similar conditions to determine whether solar tracking increases the electrical energy delivered to the golf cart’s battery.
