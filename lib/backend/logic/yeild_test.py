def primes():
    print('*')
    yield 2
    print('*')
    yield 3
    print('*')
    yield 5
    print('*')
    yield 7
    print('*')
    yield 11
    print('*')
    yield 13


for p in primes():
    if p < 7:
        print(p)
    else:
        break