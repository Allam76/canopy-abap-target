** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_digits_grammar definition public
    create public.
  public section.
    types string_string_tab type table of stringtab with empty key.

    class-data failure_node type ref to zcl_canopy_parser_tree_node.
    data input_size type i.
    data offset type i.
    data failure type i.

    data input type string.
    data expected type string_string_tab.
    data actions type ref to zif_canopy_action.

    class-methods class_constructor.
    class-data regex_1 type ref to cl_abap_regex.
    methods _read_root returning value(result) type ref to zcl_canopy_parser_tree_node.
    methods _read_digits returning value(result) type ref to zcl_canopy_parser_tree_node.
  private section.
    types: begin of ty_rule_type,
                key type i,
                value type ref to cache_record,
            end of ty_rule_type,
            ty_rule_type_tab type table of ty_rule_type with empty key.

    types: begin of ty_hash_int_type,
                key type i,
                value type ref to cache_record,
            end of ty_hash_int_type,
            ty_hash_int_type_tab type table of ty_hash_int_type with empty key.

    types: begin of ty_hash_label_type,
                key type string,
                value type ty_hash_int_type_tab,
            end of ty_hash_label_type,
            hash_label_type_tab type table of ty_hash_label_type with empty key.

    data cache type hash_label_type_tab.
endclass.
class zcl_digits_grammar implementation.
  method class_constructor.
    regex_1 = new cl_abap_regex( pattern = '[0-9]' ).
  endmethod.

  method _read_root.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'root' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'root' ] ).
      data(rule) = cache[ key = 'root' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'root' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      data(address1) = failure_node.
      data chunk0 type string.
      data(max0) = offset + 3.
      if max0 <= input_size.
        chunk0 = substring( val = input off = offset len = max0 - offset ).
      endif.
      if chunk0 is not initial and chunk0 = `foo`.
        address1 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = offset len = offset + 3 - offset )
                    offset = offset
                    elements = null ).
        offset = offset + 3.
      else.
        address1 = failure_node.
        if offset > failure.
          failure = offset.
        endif.
        if offset = failure.
          append value #( ( `digits::root` ) ( `\"foo\"` ) ) to expected.
        endif.
      endif.
      if address1 <> failure_node.
        append address1 to elements0.
        data(address2) = failure_node.
        data chunk1 type string.
        data(max1) = offset + 3.
        if max1 <= input_size.
          chunk1 = substring( val = input off = offset len = max1 - offset ).
        endif.
        if chunk1 is not initial and chunk1 = `bar`.
          address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = offset len = offset + 3 - offset )
                        offset = offset
                        elements = null ).
          offset = offset + 3.
        else.
          address2 = failure_node.
          if offset > failure.
            failure = offset.
          endif.
          if offset = failure.
            append value #( ( `digits::root` ) ( `\"bar\"` ) ) to expected.
          endif.
        endif.
        if address2 <> failure_node.
          append address2 to elements0.
        else.
          clear elements0.
          offset = index1.
        endif.
      else.
        clear elements0.
        offset = index1.
      endif.
      if elements0 is initial.
        address0 = failure_node.
      else.
        address0 = new zcl_digits_parser_tree_node1(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
        offset = offset.
      endif.
      if address0 <> failure_node.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

  method _read_digits.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'digits' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'digits' ] ).
      data(rule) = cache[ key = 'digits' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'digits' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      data address1 type ref to zcl_canopy_parser_tree_node.
      do.
        data chunk0 type string.
        data(max0) = offset + 1.
        if max0 <= input_size.
          chunk0 = substring( val = input off = offset len = max0 - offset ).
        endif.
        if chunk0 is not initial and regex_1->create_matcher( text = chunk0 )->match( ) = abap_true.
          address1 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = offset len = offset + 1 - offset )
                        offset = offset
                        elements = null ).
          offset = offset + 1.
        else.
          address1 = failure_node.
          if offset > failure.
            failure = offset.
          endif.
          if offset = failure.
            append value #( ( `digits::digits` ) ( `[0-9]` ) ) to expected.
          endif.
        endif.
        if address1 <> failure_node.
          append address1 to elements0.
        else.
          return.
        endif.
      enddo.
      if lines( elements0 ) >= 0.
        address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
        offset = offset.
      else.
        address0 = failure_node.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

endclass.