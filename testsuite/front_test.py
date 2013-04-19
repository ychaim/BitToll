#!/usr/bin/env python2
from testlib import register, balance, mine, request, deposit, pay, apicall, send_1btc

ip_address = "vm"
port = "3000"
url = ''.join(['http://', ip_address, ':', port])

def test_page_error():
    r = apicall("nonexistant", "hi")
    assert "error" in r
    assert r["error"] != ""

def test_login(login):
    info = login
    assert 'username' in info
    assert 'secret' in info
    assert len(info.keys()) == 2

def pytest_funcarg__login(request):
    info = register()
    assert 'username' in info
    assert 'secret' in info
    return info

def test_balance(login):
    info = balance(login['username'], login['secret'])
    assert 'balance' in info

def test_request(login):
    info = request(login['username'], login['secret'], amount=1)
    assert 'payment' in info

def test_mine(login):
    info = mine(login['username'], login['secret'])
    assert 'result' in info
    assert 'id' in info
    assert 'error' in info
    assert info['error'] is None

def pytest_funcarg__paidlogin(request, login):
    info = deposit(login['username'], login['secret'])
    assert 'address' in info
    info2 = deposit(login['username'], login['secret'])
    assert info['address'] == info2['address']

    send_1btc(info['address'])

    info = balance(login['username'], login['secret'])
    assert 'balance' in info
    assert float(info['balance']) > 0
    return login


def test_deposit(paidlogin):
    info = balance(paidlogin['username'], paidlogin['secret'])
    assert info['balance'] != "0"

def test_payment(paidlogin):
    info = request(paidlogin['username'], paidlogin['secret'], 1)
    assert 'payment' in info
    paymentid = info['payment']

    info = balance(paidlogin['username'], paidlogin['secret'])
    orig_b = info['balance']

    info = pay(paidlogin['username'], paidlogin['secret'], paymentid)
    assert 'code' in info

    info = balance(paidlogin['username'], paidlogin['secret'])
    assert orig_b == info['balance']
