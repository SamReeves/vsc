#@version 0.3.7
"""
@title e^n
@license MIT
@author magic numbers
"""
_owner: address
tab: constant(decimal[10][11]) = [[1.0, 2.7182818285, 7.3890560989, 20.0855369232, 54.5981500331, 148.4131591026, 403.4287934927, 1096.6331584285, 2980.9579870417, 8103.0839275754],
    [1.0, 1.1051709181, 1.2214027582, 1.3498588076, 1.4918246976, 1.6487212707, 1.8221188004, 2.0137527075, 2.2255409285, 2.4596031112],
    [1.0, 1.0100501671, 1.02020134, 1.030454534, 1.0408107742, 1.0512710964, 1.0618365465, 1.0725081813, 1.0832870677, 1.0941742837],
    [1.0, 1.0010005002, 1.0020020013, 1.0030045045, 1.0040080107, 1.0050125209, 1.0060180361, 1.0070245573, 1.0080320855, 1.0090406218],
    [1.0, 1.000100005, 1.00020002, 1.000300045, 1.00040008, 1.000500125, 1.00060018, 1.0007002451, 1.0008003201, 1.0009004051],
    [1.0, 1.00001, 1.0000200002, 1.0000300005, 1.0000400008, 1.0000500013, 1.0000600018, 1.0000700025, 1.0000800032, 1.0000900041],
    [1.0, 1.000001, 1.000002, 1.000003, 1.000004, 1.000005, 1.000006, 1.000007, 1.000008, 1.000009],
    [1.0, 1.0000001, 1.0000002, 1.0000003, 1.0000004, 1.0000005, 1.0000006, 1.0000007, 1.0000008, 1.0000009],
    [1.0, 1.00000001, 1.00000002, 1.00000003, 1.00000004, 1.00000005, 1.00000006, 1.00000007, 1.00000008, 1.00000009],
    [1.0, 1.000000001, 1.000000002, 1.000000003, 1.000000004, 1.000000005, 1.000000006, 1.000000007, 1.000000008, 1.000000009],
    [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0000000001, 1.0000000001, 1.0000000001, 1.0000000001]]

@external
def __init__():
    self._owner = msg.sender

@internal
@pure
def multiply_exponents(n: decimal) -> decimal:
    # param n = the exponent value applied to e
    # returns decimal: e^n
    r: uint256 = convert(floor(n), uint256)
    f: uint256 = convert((n - convert(r, decimal)) * 10000000000.0, uint256)
    result: decimal = tab[0][r % 10]
    r /= 10
    if r > 0:
        for i in range(1000):
            result *= tab[0][9]
            r -= 1
            if r == 0:
                break
    for i in range(10):
        result *= tab[i + 1][f % 10]
        f /= 10
    return result

@external
def exp_n(n: decimal):
    # calls the multiply_exponents function
    assert n >= 0.0, "Negative powers are not supported."
    raw_call(msg.sender, convert(self.multiply_exponents(n), bytes32))

@external
def unalive():
    # allows the owner to unalive the contract
    assert msg.sender == self._owner, "Only the owner can unalive the contract."
    selfdestruct(self._owner)

@external
def change_owner(new: address):
    # changes the owner of the contract
    assert msg.sender == self._owner, "Only the owner can change the owner."
    assert new != ZERO_ADDRESS, "The new owner cannot be the zero address."
    assert new != self._owner, "The new owner cannot be the same as the old owner."
    self._owner = new