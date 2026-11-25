# Experimental Analysis — Solar Charging Analysis

## 1. Purpose and Justification

The purpose of this experiment was to establish the charging performance of the original Lani EV fixed-panel solar charging system before implementing the team's solar-tracking design. Both systems are intended to support solar charging while the golf cart is moving. The team's proposed design adds solar tracking when the cart is parked, with the goal of increasing the electrical energy delivered to the battery by improving the panel's alignment with sunlight.

The experiment provides baseline measurements of battery-side charging voltage, current, power, estimated energy, illuminance, and battery state of charge (SOC). These measurements relate to the project's objective of improving solar charging performance. A quantitative conclusion about improvement cannot be made until the tracking configuration is tested under comparable conditions.

## 2. Detailed Procedure

### 2.1 Equipment and test configuration

| Equipment | Make and model | Use |
|---|---|---|
| Digital multimeter | Fluke 15B+ | Measure DC charging voltage and current |
| Illuminance meter | URCERI MT-912 | Measure illuminance (lux) |
| Solar charging system | Original Lani EV fixed-panel configuration | Baseline system under test |

Testing was conducted behind the Ashraf Islam Engineering Building on Stadium Drive, between University Drive and West 10th Street. The golf cart was positioned outdoors with the fixed solar panel exposed to sunlight and with no intentional shading of the panel. The team collected readings at approximately 25-minute intervals on five separate days. At each interval, the team recorded the measurement time, voltage, current, illuminance, and battery SOC.

The voltage and current measurements were taken between the MPPT charge controller and the battery to determine the charging power delivered to the battery. This measurement location will also be used when testing the team's solar-tracking design to ensure a consistent comparison between the original and modified systems. The photograph below identifies the connection location.

<img src="measurement_disconnect.jpeg" width="350">

*Figure 1. Disconnects beneath the original solar panel at the controller-to-battery measurement location.*

For illuminance readings, the light-meter sensor was positioned parallel to the panel surface and kept unobstructed. During each test, the team positioned the golf cart in an area with direct sunlight and collected voltage, current, illuminance, and battery percentage measurements at approximately 25-minute intervals. The same measurement locations and procedures were used throughout testing to maintain consistency between the results.

### 2.2 Calculations

Battery-side charging power was calculated from the recorded voltage and current:

$$P = VI$$

where $P$ is power in watts, $V$ is measured voltage in volts, and $I$ is measured current in amperes.

Since an irradiance meter was unavailable during testing, the team used a URCERI MT-912 illuminance meter to measure sunlight intensity. The recorded illuminance values were converted to estimated irradiance using the following equation:

$$G_{\mathrm{est}} = \frac{L}{122}$$

where $L$ is illuminance in lux, $G_{\text{est}}$ is estimated irradiance in W/m², and 122 lm/W is the assumed daylight luminous efficacy. Because this conversion depends on sunlight conditions, the calculated irradiance values are approximations.

Charging energy was estimated from the sampled charging power using the trapezoidal approximation:

$$E_{\mathrm{est}} \approx \sum_{i=1}^{n-1}\frac{P_i+P_{i+1}}{2}\,(t_{i+1}-t_i)$$

where time differences are expressed in hours and the resulting energy is in watt-hours. These energy estimates describe the sampled testing intervals; they are not direct battery energy-meter measurements.

## 3. Expected Results

The team expected the original fixed-panel configuration to produce measurable battery charging power that would vary throughout the day as sunlight conditions and the sun's position changed. After the solar-tracking system is installed, the team expects improved alignment during parked operation to increase charging power during portions of the day, especially when the fixed panel is less favorably oriented. The principal comparison will be battery-side charging energy over a comparable test period, supported by charging-power profiles and battery SOC readings.

## 4. Actual Results

Five days of baseline testing were completed with the original fixed solar panel. The results below summarize the measurements and calculated values. For consistency, the final November 8 reading was retained in the raw data but excluded from the calculations and graphs so that all five test periods cover 4 hours and 35 minutes.

**Table 1. Average and Peak Charging Power for the Original Design**

| Test date | Average charging power (W) | Peak charging power (W) | Average estimated irradiance (W/m²) |
|---|---:|---:|---:|
| October 9, 2026 | 145.32 | 202.37 | 330.9 |
| November 3, 2026 | 138.48 | 192.75 | 350.8 |
| November 7, 2026 | 181.99 | 205.35 | 402.7 |
| November 8, 2026 | 165.27 | 179.62 | 424.7 |
| November 15, 2026 | 179.10 | 202.13 | 360.5 |

**Table 2. Estimated Charging Energy for the Original Design**

| Test date | Testing duration | Estimated charging energy (Wh) | Battery SOC start | Batter SOC end | SOC change (percentage points) |
|---|---:|---:|---:|---:|---:|
| October 9 | 4 h 35 min | 681.9 | 6% | 16% | +10 |
| November 3 | 4 h 35 min | 648.8 | 17% | 24% | +7 |
| November 7 | 4 h 35 min | 851.7 | 24% | 35% | +11 |
| November 8 | 4 h 35 min | 763.2 | 34% | 45% | +11 |
| November 15 | 4 h 35 min | 832.3 | 45% | 57% | +12 |

### 4.1 Charging power throughout the test days

<img src="4.1_power_vs_time.png" width="500">

*Figure 2. Battery-side charging power versus time for the five fixed-panel tests.*

The power traces show how charging power varied throughout each testing period. Since the measurements were taken between the MPPT controller and the battery, the recorded values represent the charging power delivered toward the battery rather than the direct electrical output of the solar panel.

### 4.2 Average charging power by date

<img src="4.2_power_by_dates.png" width="500">

*Figure 3. Average battery-side charging power for each baseline test day.*

The average charging power varied across the five testing days, with the lowest average of 138.48 W recorded on November 3 and the highest average of 181.99 W recorded on November 7.

### 4.3 Estimated charging energy by date

<img src="4.3_energy_by_dates.png" width="500">

*Figure 4. Estimated battery-side charging energy during each test period.*

Estimated charging energy ranged from 648.8 Wh on November 3 to 851.7 Wh on November 7. These values were calculated over the same 4-hour-and-35-minute test duration for all five days.

### 4.4 Battery state of charge

<img src="4.4_battery_SOC.png" width="500">

*Figure 5. Recorded battery state of charge over the five fixed-panel test days.*

Battery SOC increased during all five testing days, with increases ranging from 7 to 12 percentage points. These results show that the original fixed-panel system was able to charge the battery throughout each testing period. While SOC provides a useful indication of charging performance, it does not directly represent the amount of energy delivered to the battery.

## 5. Interpretation and Conclusions

The five baseline tests demonstrate that the original fixed-panel charging system delivered measurable electrical power toward the golf cart battery during outdoor testing. Average charging power ranged from 138.48 W to 181.99 W, with the highest recorded instantaneous power reaching 205.35 W. Estimated charging energy ranged from 648.8 Wh to 851.7 Wh over the testing periods. Battery SOC increased during all five tests, with gains ranging from 7 to 12 percentage points.

The differences in charging performance between testing days can be influenced by several factors, including sunlight intensity, weather conditions, temperature, and battery state of charge. Since irradiance was estimated using illuminance measurements and charging energy was calculated from recorded voltage and current measurements, these values provide an estimate of the system's charging performance. Overall, the results establish a baseline for evaluating the performance of the original fixed-panel solar charging system.

The baseline experiment successfully documented the charging performance of the original fixed-panel solar charging system. The collected data provides a reference for comparing the original system with the team's proposed solar-tracking design. Future testing will use similar measurement procedures to compare charging power, estimated charging energy, and battery SOC between the two configurations.

## 6. Complete, Updated Component Inventory

The following components were used in the solar charging experiment. The solar charging components were provided by the project sponsor, while the golf cart was provided by Tennessee Tech University.

| Component | Quantity | Source |
|---|---:|---|
| Solar panel | 1 | Provided by sponsor |
| MPPT charge controller | 1 | Provided by sponsor |
| Golf cart battery system | 1 | Provided by sponsor |
| Solar panel frame | 1 | Provided by sponsor |
| Golf cart | 1 | Provided by  Tennessee Tech University |