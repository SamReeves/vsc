import pytest
from brownie import *
import random

random.seed(hash(float('inf')))
start = chain.time()
base = 2.718281828459045

@pytest.fixture
def e_power(e, accounts):
    yield e.deploy({'from': accounts[0]})

def test_e(e_power):
    for i in range(10):
        x = random.randint(0, 1000)
        assert e_power.e(x) == int(base**x)