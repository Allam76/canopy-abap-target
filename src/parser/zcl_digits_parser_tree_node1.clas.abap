** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_digits_parser_tree_node1 definition public
    inheriting from zcl_canopy_parser_tree_node create public.
public section.
        methods constructor importing text type string
        offset type i
        elements type tree_node_list_tab.
endclass.

class zcl_digits_parser_tree_node1 implementation.
method constructor.
    super->constructor( text = text  offset = offset  elements = elements ).
    append value #( key = 'first' value = elements[ 1 ] ) to labelled.
    append value #( key = 'second' value = elements[ 2 ] ) to labelled.
endmethod.
endclass.
