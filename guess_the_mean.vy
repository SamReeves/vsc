# @version ^0.3.6

"""
@title Guess the Mean
@description Guess the mean donation and win the pot!
@author Sam Reeves
"""
_guesses: DynArray[uint256, 100]
_guessers : DynArray[address, 100]
_n: uint256
_winner: address
_mean: uint256
end: public(uint256)
round: public(uint256)

@external
@payable
def __init__():
    self.end = block.timestamp + (60 * 60 * 24 * 7 * 4) # 1 month
    self._guesses = []
    self._guessers = []
    self._guesses.append(msg.value)
    self._guessers.append(msg.sender)
    self._n = 1
    self.round = 1

@external
@payable
def __default__():
    assert msg.amount > 0, "How you gonna guess 0?"
    if (block.timestamp < self.end) or (n < 100):
        self._guesses.append(msg.value)
        self._guessers.append(msg.sender)
        self._n += 1
    else:
        _error: uint256[self._n]
        _winner: address = empty(address)
        _mean: uint256 = self.balance / self._n
        _min_error: uint256 = 0

        for i in range(self._n):
            _error.append(abs(self._guesses[i] - mean))
        _min_error: uint256 = min_value(_error)

        for i in range(self._n):
            if _error[i] == min_error:
                _winner = self._guessers[i]

        send(_winner, self.balance)
        
        self._guesses = []
        self._guessers = []
        self._n = 0
        self.round += 1
        self.end = block.timestamp + (60 * 60 * 24 * 7 * 4) # 1 month