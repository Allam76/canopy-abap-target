** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_digits_parser_tree_node1 definition public
    inheriting from zcl_digits_parser_tree_node create public.
  public section.
    methods constructor importing text type string
        offset type i
        elements type elements_list_tab.
endclass.

class zcl_digits_parser_tree_node1 implementation.
  method constructor.
    super( text = text  offset = offset  elements = elements ).
    append value #( ( key = 'first' value = elements[ 0 ] ) ) to labelled.
    append value #( ( key = 'second' value = elements[ 1 ] ) ) to labelled.
  endmethod.
endclass.