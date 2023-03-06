#@version 0.3.7
"""
@title pi
@description pi is the signature of a circle.
@license MIT
@author magic numbers
@input n, a decimal power of pi
@output pi^n, a decimal number
"""

_owner: private(address)
tab: constant(decimal[10][10]) = [[3.1415926536, 9.8696044011, 31.0062766803, 97.409091034, 306.0196847853, 961.3891935753, 3020.2932277768, 9488.5310160706, 29809.0993334462], [1.1212823532, 1.2572741157, 1.4097592791, 1.5807382019, 1.7724538509, 1.9874212249, 2.228460348, 2.498733263, 2.8017855133], [1.0115130699, 1.0231586906, 1.0349383881, 1.0468537062, 1.0589062061, 1.0710974672, 1.0834290873, 1.0959026821, 1.1085198863], [1.0011453853, 1.0022920826, 1.0034400932, 1.0045894188, 1.0057400608, 1.0068920207, 1.0080453001, 1.0091999004, 1.0103558232], [1.0001144795, 1.0002289722, 1.0003434779, 1.0004579968, 1.0005725288, 1.0006870739, 1.0008016321, 1.0009162034, 1.0010307878], [1.0000114474, 1.0000228949, 1.0000343425, 1.0000457902, 1.0000572381, 1.0000686862, 1.0000801343, 1.0000915826, 1.000103031], [1.0000011447, 1.0000022895, 1.0000034342, 1.0000045789, 1.0000057237, 1.0000068684, 1.0000080131, 1.0000091579, 1.0000103026], [1.0000001145, 1.0000002289, 1.0000003434, 1.0000004579, 1.0000005724, 1.0000006868, 1.0000008013, 1.0000009158, 1.0000010303], [1.0000000114, 1.0000000229, 1.0000000343, 1.0000000458, 1.0000000572, 1.0000000687, 1.0000000801, 1.0000000916, 1.000000103], [1.0000000011, 1.0000000023, 1.0000000034, 1.0000000046, 1.0000000057, 1.0000000069, 1.000000008, 1.0000000092, 1.0000000103]]

@external
def __init__():
    self._owner = msg.sender

@pure
def multiply_exponents(n: decimal) -> decimal:
    # this function refers to the table and returns x^n 
    # by multiplying values in 10 decimal places
    # param: n = the power to raise e to
    
    # split n into a whole part and a decimal part
    r: int256 = floor(n)
    f: decimal = n - convert(r, decimal)

    # create a list of every digit in f
    digits: int128[10]
    for i in range(9):
        digits[i] = floor(f * convert((10 ** i), decimal))
    
    # calculate the two parts and multiply them together
    whole: decimal = convert(r // 9, decimal) * tab([0][9]) * tab([0][r % 9])
    fraction: decimal = 1.0
    for i in range(9):
        fraction *= tab(i+1, digits[i])
    return whole * fraction

@external
def exp():
    # calls the multiply_exponents function

    assert msg.data >= 0.0, "Negative powers are not supported."
    send(msg.sender, multiply_exponents(msg.data))

@external
def unalive():
    # allows the owner to unalive the contract

    assert msg.sender == self._owner, "Only the owner can unalive the contract."
    selfdestruct(self._owner)

@external
def change_owner(new_owner: address):
    # changes the owner of the contract
    # param: new_owner = the new owner of the contract

    assert msg.sender == self._owner, "Only the owner can change the owner."
    self.owner = new_owner
