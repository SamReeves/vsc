#@version ^3.7.0

"""
@title Powers of 2.718281828459
@description This program calculates the powers of e, between 0 and 10, to 10 decimal places.
@input n, a decimal power of e in (0.0, 10.0]
@output e^n, the value of e^n
@author Magic Numbers
@license MIT
"""

owner: private(address)
tab: constant(decimal[10][10]) = \
    [[1.0, 2.7182818285, 7.3890560989, 20.0855369232, 54.5981500331, 148.4131591026, 403.4287934927, 1096.6331584285, 2980.9579870417, 8103.0839275754],
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
    self.owner = msg.sender

@external
def exp():
    """
    @notice This is the callable function. It calls pure multiply_exponents function,
    and returns the value of e^n.
    """
    assert msg.data >= 0.0, "Negative powers are not supported."
    assert msg.data <= 10.0, "Powers greater than or equal to 10 are not supported."
    send(msg.sender, multiply_exponents(msg.data))

@pure
def multiply_exponents(n: decimal) -> decimal:
    """
    @notice This function refers to the table of powers of e, and returns the value of
    e^n by multiplying known exponent values. This is limited to 10 decimal places.
    """
    # split n into a whole part and a decimal part
    r: int256 = floor(n)
    f: decimal = n - convert(r, decimal)

    # create a list of every digit in f
    digits: int128[10]
    for i in range(9):
        digits[i] = floor(f * convert((10 ** i), decimal))
    
    # calculate the two parts and multiply them together
    whole: decimal = tab(0, r)
    fraction: decimal = 1.0
    for i in range(9):
        fraction *= tab(i+1, digits[i])
    return whole * fraction

@external
def unalive():
    """
    @notice This function allows the owner to unalive the contract.
    """
    assert msg.sender == self.owner, "Only the owner can unalive the contract."
    selfdestruct(self.owner)

@external
def change_owner(new_owner: address):
    """
    @notice Change the owner of the contract.
    @param new_owner The new owner of the contract.
    """
    assert msg.sender == self.owner, "Only the owner can change the owner."
    self.owner = new_owner