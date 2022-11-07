** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_exps_grammar definition public
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
    class-data regex_2 type ref to cl_abap_regex.
    methods _read_expression returning value(result) type ref to zcl_canopy_parser_tree_node.
    methods _read_term returning value(result) type ref to zcl_canopy_parser_tree_node.
    methods _read_factor returning value(result) type ref to zcl_canopy_parser_tree_node.
    methods _read_integer returning value(result) type ref to zcl_canopy_parser_tree_node.
    methods _read__ returning value(result) type ref to zcl_canopy_parser_tree_node.
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
class zcl_exps_grammar implementation.
  method class_constructor.
    regex_1 = new cl_abap_regex( pattern = '[0-9]' ).
    regex_2 = new cl_abap_regex( pattern = '[ \t\n\r]' ).
  endmethod.

  method _read_expression.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'expression' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'expression' ] ).
      data(rule) = cache[ key = 'expression' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'expression' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      clear elements0.
      data(address1) = failure_node.
      address1 = _read_term( ).
      if address1 <> failure_node.
        append address1 to elements0.
        data(address2) = failure_node.
        data(index2) = offset.
        data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
        clear elements1.
        data address3 type ref to zcl_canopy_parser_tree_node.
        clear address3.
        do.
          data(index3) = offset.
          data elements2 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
          clear elements2.
          data(address4) = failure_node.
          address4 = _read__( ).
          if address4 <> failure_node.
            append address4 to elements2.
            data(address5) = failure_node.
            data(index4) = offset.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 1.
            if max0 <= input_size.
              chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `+`.
              address5 = new zcl_canopy_parser_tree_node(
                                text = substring( val = input off = offset len = offset + 1 - offset )
                                offset = offset
                                elements = value #( ) ).
              offset = offset + 1.
            else.
              address5 = failure_node.
              if offset > failure.
                failure = offset.
              endif.
              if offset = failure.
                append value #( ( `exps::expression` ) ( `\"+\"` ) ) to expected.
              endif.
            endif.
            if address5 = failure_node.
              offset = index4.
              data chunk1 type string.
              clear chunk1.
              data(max1) = offset + 1.
              if max1 <= input_size.
                chunk1 = substring( val = input off = offset len = max1 - offset ).
              endif.
              if chunk1 is not initial and chunk1 = `-`.
                address5 = new zcl_canopy_parser_tree_node(
                                    text = substring( val = input off = offset len = offset + 1 - offset )
                                    offset = offset
                                    elements = value #( ) ).
                offset = offset + 1.
              else.
                address5 = failure_node.
                if offset > failure.
                  failure = offset.
                endif.
                if offset = failure.
                  append value #( ( `exps::expression` ) ( `\"-\"` ) ) to expected.
                endif.
              endif.
              if address5 = failure_node.
                offset = index4.
              endif.
            endif.
            if address5 <> failure_node.
              append address5 to elements2.
              data(address6) = failure_node.
              address6 = _read__( ).
              if address6 <> failure_node.
                append address6 to elements2.
                data(address7) = failure_node.
                address7 = _read_term( ).
                if address7 <> failure_node.
                  append address7 to elements2.
                else.
                  clear elements2.
                  offset = index3.
                endif.
              else.
                clear elements2.
                offset = index3.
              endif.
            else.
              clear elements2.
              offset = index3.
            endif.
          else.
            clear elements2.
            offset = index3.
          endif.
          if elements2 is initial.
            address3 = failure_node.
          else.
            address3 = new zcl_exps_parser_tree_node2(
                            text = substring( val = input off = index3 len = offset - index3 )
                            offset = index3
                            elements = elements2 ).
            offset = offset.
          endif.
          if address3 <> failure_node.
            append address3 to elements1.
          else.
            exit.
          endif.
        enddo.
        if lines( elements1 ) >= 0.
          address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index2 len = offset - index2 )
                        offset = index2
                        elements = elements1 ).
          offset = offset.
        else.
          address2 = failure_node.
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
        address0 = new zcl_exps_parser_tree_node1(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
        offset = offset.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

  method _read_term.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'term' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'term' ] ).
      data(rule) = cache[ key = 'term' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'term' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      clear elements0.
      data(address1) = failure_node.
      address1 = _read_factor( ).
      if address1 <> failure_node.
        append address1 to elements0.
        data(address2) = failure_node.
        data(index2) = offset.
        data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
        clear elements1.
        data address3 type ref to zcl_canopy_parser_tree_node.
        clear address3.
        do.
          data(index3) = offset.
          data elements2 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
          clear elements2.
          data(address4) = failure_node.
          address4 = _read__( ).
          if address4 <> failure_node.
            append address4 to elements2.
            data(address5) = failure_node.
            data(index4) = offset.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 1.
            if max0 <= input_size.
              chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `*`.
              address5 = new zcl_canopy_parser_tree_node(
                                text = substring( val = input off = offset len = offset + 1 - offset )
                                offset = offset
                                elements = value #( ) ).
              offset = offset + 1.
            else.
              address5 = failure_node.
              if offset > failure.
                failure = offset.
              endif.
              if offset = failure.
                append value #( ( `exps::term` ) ( `\"*\"` ) ) to expected.
              endif.
            endif.
            if address5 = failure_node.
              offset = index4.
              data chunk1 type string.
              clear chunk1.
              data(max1) = offset + 1.
              if max1 <= input_size.
                chunk1 = substring( val = input off = offset len = max1 - offset ).
              endif.
              if chunk1 is not initial and chunk1 = `/`.
                address5 = new zcl_canopy_parser_tree_node(
                                    text = substring( val = input off = offset len = offset + 1 - offset )
                                    offset = offset
                                    elements = value #( ) ).
                offset = offset + 1.
              else.
                address5 = failure_node.
                if offset > failure.
                  failure = offset.
                endif.
                if offset = failure.
                  append value #( ( `exps::term` ) ( `\"/\"` ) ) to expected.
                endif.
              endif.
              if address5 = failure_node.
                offset = index4.
              endif.
            endif.
            if address5 <> failure_node.
              append address5 to elements2.
              data(address6) = failure_node.
              address6 = _read__( ).
              if address6 <> failure_node.
                append address6 to elements2.
                data(address7) = failure_node.
                address7 = _read_factor( ).
                if address7 <> failure_node.
                  append address7 to elements2.
                else.
                  clear elements2.
                  offset = index3.
                endif.
              else.
                clear elements2.
                offset = index3.
              endif.
            else.
              clear elements2.
              offset = index3.
            endif.
          else.
            clear elements2.
            offset = index3.
          endif.
          if elements2 is initial.
            address3 = failure_node.
          else.
            address3 = new zcl_exps_parser_tree_node4(
                            text = substring( val = input off = index3 len = offset - index3 )
                            offset = index3
                            elements = elements2 ).
            offset = offset.
          endif.
          if address3 <> failure_node.
            append address3 to elements1.
          else.
            exit.
          endif.
        enddo.
        if lines( elements1 ) >= 0.
          address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index2 len = offset - index2 )
                        offset = index2
                        elements = elements1 ).
          offset = offset.
        else.
          address2 = failure_node.
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
        address0 = new zcl_exps_parser_tree_node3(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
        offset = offset.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

  method _read_factor.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'factor' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'factor' ] ).
      data(rule) = cache[ key = 'factor' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'factor' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data(index2) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      clear elements0.
      data(address1) = failure_node.
      data chunk0 type string.
      clear chunk0.
      data(max0) = offset + 1.
      if max0 <= input_size.
        chunk0 = substring( val = input off = offset len = max0 - offset ).
      endif.
      if chunk0 is not initial and chunk0 = `(`.
        address1 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = offset len = offset + 1 - offset )
                    offset = offset
                    elements = value #( ) ).
        offset = offset + 1.
      else.
        address1 = failure_node.
        if offset > failure.
          failure = offset.
        endif.
        if offset = failure.
          append value #( ( `exps::factor` ) ( `\"(\"` ) ) to expected.
        endif.
      endif.
      if address1 <> failure_node.
        append address1 to elements0.
        data(address2) = failure_node.
        address2 = _read__( ).
        if address2 <> failure_node.
          append address2 to elements0.
          data(address3) = failure_node.
          address3 = _read_expression( ).
          if address3 <> failure_node.
            append address3 to elements0.
            data(address4) = failure_node.
            address4 = _read__( ).
            if address4 <> failure_node.
              append address4 to elements0.
              data(address5) = failure_node.
              data chunk1 type string.
              clear chunk1.
              data(max1) = offset + 1.
              if max1 <= input_size.
                chunk1 = substring( val = input off = offset len = max1 - offset ).
              endif.
              if chunk1 is not initial and chunk1 = `)`.
                address5 = new zcl_canopy_parser_tree_node(
                                    text = substring( val = input off = offset len = offset + 1 - offset )
                                    offset = offset
                                    elements = value #( ) ).
                offset = offset + 1.
              else.
                address5 = failure_node.
                if offset > failure.
                  failure = offset.
                endif.
                if offset = failure.
                  append value #( ( `exps::factor` ) ( `\")\"` ) ) to expected.
                endif.
              endif.
              if address5 <> failure_node.
                append address5 to elements0.
              else.
                clear elements0.
                offset = index2.
              endif.
            else.
              clear elements0.
              offset = index2.
            endif.
          else.
            clear elements0.
            offset = index2.
          endif.
        else.
          clear elements0.
          offset = index2.
        endif.
      else.
        clear elements0.
        offset = index2.
      endif.
      if elements0 is initial.
        address0 = failure_node.
      else.
        address0 = new zcl_exps_parser_tree_node5(
                    text = substring( val = input off = index2 len = offset - index2 )
                    offset = index2
                    elements = elements0 ).
        offset = offset.
      endif.
      if address0 = failure_node.
        offset = index1.
        address0 = _read_integer( ).
        if address0 = failure_node.
          offset = index1.
        endif.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

  method _read_integer.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = 'integer' value = value #( ) ) to cache.
    if line_exists( cache[ key = 'integer' ] ).
      data(rule) = cache[ key = 'integer' ]-value.
    endif.
    if rule is initial.
      append value #( key = 'integer' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      clear elements0.
      data(address1) = failure_node.
      address1 = _read__( ).
      if address1 <> failure_node.
        append address1 to elements0.
        data(address2) = failure_node.
        data(index2) = offset.
        data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
        clear elements1.
        data address3 type ref to zcl_canopy_parser_tree_node.
        clear address3.
        do.
          data chunk0 type string.
          clear chunk0.
          data(max0) = offset + 1.
          if max0 <= input_size.
            chunk0 = substring( val = input off = offset len = max0 - offset ).
          endif.
          if chunk0 is not initial and regex_1->create_matcher( text = chunk0 )->match( ) = abap_true.
            address3 = new zcl_canopy_parser_tree_node(
                            text = substring( val = input off = offset len = offset + 1 - offset )
                            offset = offset
                            elements = value #( ) ).
            offset = offset + 1.
          else.
            address3 = failure_node.
            if offset > failure.
              failure = offset.
            endif.
            if offset = failure.
              append value #( ( `exps::integer` ) ( `[0-9]` ) ) to expected.
            endif.
          endif.
          if address3 <> failure_node.
            append address3 to elements1.
          else.
            exit.
          endif.
        enddo.
        if lines( elements1 ) >= 1.
          address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index2 len = offset - index2 )
                        offset = index2
                        elements = elements1 ).
          offset = offset.
        else.
          address2 = failure_node.
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
        address0 = new zcl_exps_parser_tree_node6(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
        offset = offset.
      endif.
      append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
    endif.
    result = address0.
  endmethod.

  method _read__.
    data(address0) = failure_node.
    data(index0) = offset.
    append value #( key = '_' value = value #( ) ) to cache.
    if line_exists( cache[ key = '_' ] ).
      data(rule) = cache[ key = '_' ]-value.
    endif.
    if rule is initial.
      append value #( key = '_' value = rule ) to cache.
    endif.
    if line_exists( rule[ key = offset ] ).
      address0 = rule[ key = offset ]-value->node.
      offset = rule[ key = offset ]-value->tail.
    else.
      data(index1) = offset.
      data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
      clear elements0.
      data address1 type ref to zcl_canopy_parser_tree_node.
      clear address1.
      do.
        data chunk0 type string.
        clear chunk0.
        data(max0) = offset + 1.
        if max0 <= input_size.
          chunk0 = substring( val = input off = offset len = max0 - offset ).
        endif.
        if chunk0 is not initial and regex_2->create_matcher( text = chunk0 )->match( ) = abap_true.
          address1 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = offset len = offset + 1 - offset )
                        offset = offset
                        elements = value #( ) ).
          offset = offset + 1.
        else.
          address1 = failure_node.
          if offset > failure.
            failure = offset.
          endif.
          if offset = failure.
            append value #( ( `exps::_` ) ( `[ \\t\\n\\r]` ) ) to expected.
          endif.
        endif.
        if address1 <> failure_node.
          append address1 to elements0.
        else.
          exit.
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