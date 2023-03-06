#@version 0.3.7
"""
@title tau
@description tau is also the signature of a wave.
@license MIT
@author Magic Numbers
@input n, a decimal power of tau
@output tau^n, a decimal number
"""

_owner: private(address)
tab: constant(decimal[10][10]) = [[6.2831853072, 39.4784176044, 248.0502134424, 1558.545456544, 9792.629913129, 61528.9083888195, 386597.5331554293, 2429063.940114066, 15262258.858724454], [1.2017606702, 1.4442287084, 1.7356172606, 2.0857965623, 2.5066282746, 3.0123672753, 3.6201445156, 4.3505472993, 5.2283166382], [1.0185486997, 1.0374414537, 1.0566846436, 1.0762847698, 1.0962484528, 1.1165824361, 1.1372935884, 1.1583889057, 1.1798755136], [1.001839567, 1.003682518, 1.0055288592, 1.0073785969, 1.0092317374, 1.0110882868, 1.0129482514, 1.0148116376, 1.0166784516], [1.0001838046, 1.000367643, 1.0005515151, 1.0007354211, 1.0009193609, 1.0011033345, 1.0012873419, 1.0014713831, 1.0016554581], [1.0000183789, 1.0000367582, 1.0000551378, 1.0000735178, 1.0000918981, 1.0001102787, 1.0001286597, 1.000147041, 1.0001654226], [1.0000018379, 1.0000036758, 1.0000055136, 1.0000073515, 1.0000091894, 1.0000110273, 1.0000128652, 1.0000147031, 1.000016541], [1.0000001838, 1.0000003676, 1.0000005514, 1.0000007352, 1.0000009189, 1.0000011027, 1.0000012865, 1.0000014703, 1.0000016541], [1.0000000184, 1.0000000368, 1.0000000551, 1.0000000735, 1.0000000919, 1.0000001103, 1.0000001287, 1.000000147, 1.0000001654], [1.0000000018, 1.0000000037, 1.0000000055, 1.0000000074, 1.0000000092, 1.000000011, 1.0000000129, 1.0000000147, 1.0000000165]]

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
