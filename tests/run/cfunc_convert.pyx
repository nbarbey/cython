from libc.math cimport sqrt, log

cdef void empty_cfunc():
    print "here"

def call_empty_cfunc():
    """
    >>> call_empty_cfunc()
    here
    """
    cdef object py_func = empty_cfunc
    py_func()

cdef double square_c(double x):
    return x * x

def call_square_c(x):
    """
    >>> call_square_c(2)
    4.0
    >>> call_square_c(-7)
    49.0
    """
    cdef object py_func = square_c
    return py_func(x)

cdef long long rad(long long x):
    cdef long long rad = 1
    for p in range(2, <long long>sqrt(x) + 1):
        if x % p == 0:
            rad *= p
            while x % p == 0:
                x //= p
        if x == 1:
            break
    return rad

cdef bint abc(long long a, long long b, long long c) except -1:
    if a + b != c:
        raise ValueError("Not a valid abc candidate: (%s, %s, %s)" % (a, b, c))
    return rad(a*b*c) < c

def call_abc(a, b, c):
    """
    >>> call_abc(2, 3, 5)
    False
    >>> call_abc(1, 63, 64)
    True
    >>> call_abc(2, 3**10 * 109, 23**5)
    True
    >>> call_abc(1, 1, 1)
    Traceback (most recent call last):
    ...
    ValueError: Not a valid abc candidate: (1, 1, 1)
    """
    cdef object py_func = abc
    return py_func(a, b, c)


ctypedef double foo
cdef foo test_typedef_cfunc(foo x):
    return x

def test_typedef(x):
    """
    >>> test_typedef(100)
    100.0
    """
    return (<object>test_typedef_cfunc)(x)


cdef object test_object_params_cfunc(a, b):
    return a, b

def test_object_params(a, b):
    """
    >>> test_object_params(1, 'a')
    (1, 'a')
    """
    return (<object>test_object_params_cfunc)(a, b)


cdef tuple test_builtin_params_cfunc(list a, dict b):
    return a, b

def test_builtin_params(a, b):
    """
    >>> test_builtin_params([], {})
    ([], {})
    >>> test_builtin_params(1, 2)
    Traceback (most recent call last):
    ...
    TypeError: Cannot convert int to list
    """
    return (<object>test_builtin_params_cfunc)(a, b)


cdef class A:
    def __repr__(self):
        return self.__class__.__name__

cdef class B(A):
    pass

cdef A test_cdef_class_params_cfunc(A a, B b):
    return b

def test_cdef_class_params(a, b):
    """
    >>> test_cdef_class_params(A(), B())
    B
    >>> test_cdef_class_params(B(), A())
    Traceback (most recent call last):
    ...
    TypeError: Cannot convert cfunc_convert.A to cfunc_convert.B
    """
    return (<object>test_cdef_class_params_cfunc)(a, b)
