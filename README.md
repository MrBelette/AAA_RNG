# AAA_RNG

The Academy of Actuaries of America produce the stochastic investment model for US reserving calculations.
The Excel spreadsheet uses, as far as I can tell, an undocumented random number generator.
This Julia package will replicate the RNG calculation and examine it's properties.
For example, the period of the RNG appears to be close to 259200x16807 = cm1*cm2/8.
</br>
The RNG appears to fail the small Crush test.
</br>
TBC.
