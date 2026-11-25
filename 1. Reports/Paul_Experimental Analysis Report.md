**Electrical verification and standards**

**Purpose and expected result.** Ensure all internal electrical components followed set criteria as outlined in ANSI/OPEI Z130.1-2020 for electric golf carts. Determine if any improvements are needed for the wiring or other internal components. It was expected that each criterion would be within a satisfactory range and no improvements would be necessary.

**Procedure.** Before making improvements on any wire or fuses found on the golf cart, the polarity and continuity of each device needs inspection. This determines if the wires are properly labeled and if there is a closed loop present. If the device is not properly wired, meaning the polarity of the unit is reversed, the result can range from no effect to internal components damaged or destroyed caused by overheating or fire. Before testing for polarity or continuity, ensure the device is properly disconnected from the main power supply and other devices. To check for the polarity of each device, a UNI-T UT161B multimeter was utilized to test the voltage across the terminals. A positive voltage indicates the terminals are correctly labeled. However, a negative voltage denotes the terminals are flipped and must be fixed quickly.

| Device Name          | Voltage Across Terminals |
|----------------------|--------------------------|
| Golf Cart Controller | 0.538V                   |
| Charger              | 0.000V                   |
| Display/Power Button | 0.000V                   |
| MPPT                 | 14.50V                   |

The multimeter displayed a positive voltage for the golf cart controller and MPPT, signifying each terminal was properly labeled. The test for the MPPT was conducted at the battery output terminals. The solar panel input terminals of the MPPT were prewired when given to the team. When checking the charger and display/power button, no voltage was read by the multimeter. This occurs due to the charger being a device that sends voltage rather than receiving. The display and power button follow similar rules, communicating with the LiFePO<sub>4</sub> battery rather than receiving a voltage. To ensure the connections were properly labeled, the team communicated with LaniEV’s engineers about the matter. Following the conversation with LaniEV’s engineers, all terminals were deemed properly labeled.

The previously used multimeter was utilized again, to check for continuity to verify that each device was a closed loop. This indicates there is no short circuit, open circuit, or ground fault occurring in the wires or inside the device. Each test was conducted by touching the corresponding positive and negative probe to the terminals of the specified device to create the closed loop.

| Device Name          | Resistance |
|----------------------|------------|
| Golf Cart Controller | 0.000 Ω    |
| Charger              | 0.000 Ω    |
| Display/Power Button | 0.000 Ω    |
| MPPT                 | 0.000 Ω    |

The multimeter displayed an ohmage of zero for each device, indicating there was no fault present in the wiring or device.

Section 9.1.3 of ANSI/OPEI Z130.1-2020 requires the system to have adequate wiring capacity for the expected load. The American Wire Gauge (AWG) is displayed on the insulation of the wire. If the information on the insulation is smudged or not visible, wire strippers can be used to determine the gauge of the wire. Using the AWG and an online conversion table, the rated amperage of each wire can be determined.

| Device Name           | American Wire Gauge (AWG) | Rated Amperage |
|-----------------------|---------------------------|----------------|
| Golf Cart Controller  | 4 AWG                     | 70-85 A        |
| Charger - Wall Outlet | 14 AWG                    | 15 A           |
| Charger – Battery     | 14AWG\*2C+20AWG\*4C       | 15 A and 5 A   |
| Display/Power Button  | 16 AWG                    | 10 A           |
| MPPT                  | 14 AWG                    | 15 A           |

The maximum current drawn by the battery when the golf cart is in motion is approximately 21 amps. Therefore, the 4 AWG wires for the controller met our need. It can be replaced for a bigger gauge wire to reduce the needed space in the battery compartment if deemed necessary. The connection between the charger and battery contains six total wires, two wires rated at 14 AWG and four wires rated at 20 AWG. The 14 AWG wires transport most of the voltage created by the charger, while the 20 AWG wires help control how much extra voltage gets carried to the battery. This combination allows for safe transportation of voltage between the two devices. The 14 AWG wire used for the wall outlet connection of the charger allows for the maximum amperage the device can handle, thus fitting the device’s requirements. The MPPT and display/power button wires fit the load of each device, matching the amperage that is supplied and used to communicate with the battery.

Referencing the 2019 Precedent Golf Car Maintenance and Service Manual, there are two fuses found in the main harness electric schematic, one is rated for 2 amps and the other for 15 amps. The battery supplies the system with approximately 13 amps under normal load. The 2 amp fuse is connected to an output for a car extension. For our purposes, we do not intend to use a car extension. The 15 amp fuse is connected to the positive battery auxiliary output of the controller, which is responsible for protecting the internal electronics by removing the connection between the controller and key switch, should the fuse blow. Because the battery delivers an amperage of 13 amps, the 15 amp fuse will work for our intended purpose.

Section 9.1.1 and 9.1.2 of ANSI/OPEI Z130.1-2020 require the wiring system to be ground to the battery, not the golf cart, and for all wires to be placed with adequate clearance to prevent damage while the golf cart is in use. To adhere to section 9.1.1, the negative terminal of the battery serves as the ground point for the entire circuit. Before installation of the battery and charger, the team ensured adherence to section 9.1.2. This was accomplished by confirming all wires coming to and from the battery compartment were placed so no two surfaces pinched a wire and would not melt due to extraneous heat.

Section 9.1.4 of ANSI/OPEI Z130.1-2020 requires adequate guarding so the nominal voltage does not exceed 60 Vdc or 30 Vac. To adhere to this criterion, the team was provided a 51.2V LiFePO<sub>4</sub> battery by LaniEV. Using the Olelon Connect app, the team was able to deduce that the battery held no more than 52.60V, under the nominal voltage.

Referencing the datasheet, the LiFePO<sub>4</sub> battery has a nominal voltage of 51.2V, a recommended charging current of 30A with a maximum of 40A, and a discharging current of 480A in the span of 3 seconds with 400A in the span of 30 seconds. Using the Olelon Connect app, the nominal voltage of the battery is 52.60V, produces a discharge voltage of approximately 13.4 amps every second under a normal load, approximately 18.5 amps every second under an extraneous load, and receives an amperage of approximately 21 from the charger. Each value found through the Olelon connect app is within range of the datasheet for the team’s battery.

The specifications for the charger are located on the side of the device. It has an input voltage range of 100 to 240 Vac with a maximum current of 12 amps. The output of the charger is 58.4 Vdc with an amperage of 25 amps. The standard non-industrial outlet delivers approximately 120Vac, with an industrial outlet delivering 240Vac, within range of the charger’s specifications. Using the Olelon Connect app, the charger delivers an amperage of approximately 21 amps when connected to a non-industrial outlet. These values indicate the charger operates within range of the specifications outlined.

At the time of writing this report, it should be duly noted the team’s golf cart did not come equipped with a 48V to 12V DC-DC converter. This does not affect the brake lights and turn signals. This issue causes non-functioning headlights.

All safety standards and verifications were found to be upheld and within adequate range. Verifying device specifications now allows future teams to work safely on the golf cart, significantly reducing the possibility of complications that could arise.

**Statement of Contribution**

**Landon Paul** Landon worked to ensure all standards and verifications were upheld during the installation of the devices to the golf cart.

**Citated Sources**

The Ninth section of the American National Standard for Golf Cars – Safety and Performance, ANSI/OPEI Z130.1-2020, outlined the criteria for electric golf cars.

The datasheet for LiFePO<sub>4</sub> battery found at <https://www.energy-xprt.com/products/olelon-model-s51105-512v-105ah-lifepo4-large-voltage-smart-golf-cart-battery-1064409> was referenced to ensure the battery operated within expected parameters.

The 2019 Precedent Golf Car Maintenance and Service Manual provided with the golf cart outlined the internal wiring of each system.

The conversion table used for the AWG table is provided by Mid America Wire and Cable, found at <https://midamericawirecable.com/resources/mtw-wire-ampacity-chart> Table 28.1 UL 508A for Copper Conductors was referenced for the ampacity calculations
