** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class test_simple definition final for testing 
  duration short
  risk level harmless.

  private section.
    methods first_test for testing raising cx_static_check.
endclass.


class test_simple implementation.

  method simple_test.
    data(node) = ZCL_DIGITS_PARSER=>PARSE( <text> ).
    cl_aunit_assert=>assert_bound( act = node msg = 'node should be bound' ).
  endmethod.

endclass.
