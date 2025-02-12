#!/usr/bin/env python
f_ssc = 1789770/16
f_s12 = 894665/16
f_super = 3000000/16
f_ccp1 = 1000000/16
f_ccp2 = 2000000/16

major = [0, 2, 4, 5, 7, 9, 11, 12]
minor = [0, 2, 3, 5, 7, 8, 10, 12]

print("CM")
f0 = 261.625565
for n in major:
    f = f0*pow(2, n/12)
    print(f'{f:8.2f} {int(f_ssc/f+.5):4} {int(f_s12/f+.5):4} {int(f_super/f+.5):4} {int(f_ccp2/f+.5):4}')

print("Cm")
for n in minor:
    f = f0*pow(2, n/12)
    print(f'{f:8.2f} {int(f_ssc/f+.5):4} {int(f_s12/f+.5):4} {int(f_super/f+.5):4} {int(f_ccp2/f+.5):4}')

print("AM")
f0 = 440
for n in major:
    f = f0*pow(2, n/12)
    print(f'{f:8.2f} {int(f_ssc/f+.5):4} {int(f_s12/f+.5):4} {int(f_super/f+.5):4} {int(f_ccp2/f+.5):4}')

print("Am")
for n in minor:
    f = f0*pow(2, n/12)
    print(f'{f:8.2f} {int(f_ssc/f+.5):4} {int(f_s12/f+.5):4} {int(f_super/f+.5):4} {int(f_ccp2/f+.5):4}')
