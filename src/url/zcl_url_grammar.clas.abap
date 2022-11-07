** This file was generated from
** See https://canopy.jcoglan.com/ for documentation

class zcl_url_grammar definition public
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
        class-data REGEX_1 type ref to cl_abap_regex.
        class-data REGEX_2 type ref to cl_abap_regex.
        class-data REGEX_3 type ref to cl_abap_regex.
        class-data REGEX_4 type ref to cl_abap_regex.
        class-data REGEX_5 type ref to cl_abap_regex.
        methods _read_url returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_scheme returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_host returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_hostname returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_segment returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_port returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_pathname returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_search returning value(result) type ref to zcl_canopy_parser_tree_node.
        methods _read_hash returning value(result) type ref to zcl_canopy_parser_tree_node.
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
class zcl_url_grammar implementation.
    method class_constructor.
        REGEX_1 = new cl_abap_regex( pattern = '[a-z0-9-]' ).
        REGEX_2 = new cl_abap_regex( pattern = '[0-9]' ).
        REGEX_3 = new cl_abap_regex( pattern = '[^ ?]' ).
        REGEX_4 = new cl_abap_regex( pattern = '[^ #]' ).
        REGEX_5 = new cl_abap_regex( pattern = '[^ ]' ).
    endmethod.

    method _read_url.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'url' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'url' ] ).
            data(rule) = cache[ key = 'url' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'url' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            address1 = _read_scheme( ).
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data chunk0 type string.
                clear chunk0.
                data(max0) = offset + 3.
                if max0 <= input_size.
                    chunk0 = substring( val = input off = offset len = max0 - offset ).
                endif.
                if chunk0 is not initial and chunk0 = `://`.
                    address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = offset len = offset + 3 - offset )
                        offset = offset
                        elements = value #( ) ).
                    offset = offset + 3.
                else.
                    address2 = failure_node.
                    if offset > failure.
                        failure = offset.
                    endif.
                    if offset = failure.
                        append value #( ( `URL::url` ) ( `\"://\"` ) ) to expected.
                    endif.
                endif.
                if address2 <> failure_node.
                    append address2 to elements0.
                    data(address3) = failure_node.
                    address3 = _read_host( ).
                    if address3 <> failure_node.
                        append address3 to elements0.
                        data(address4) = failure_node.
                        address4 = _read_pathname( ).
                        if address4 <> failure_node.
                            append address4 to elements0.
                            data(address5) = failure_node.
                            address5 = _read_search( ).
                            if address5 <> failure_node.
                                append address5 to elements0.
                                data(address6) = failure_node.
                                data(index2) = offset.
                                address6 = _read_hash( ).
                                if address6 = failure_node.
                                    address6 = new zcl_canopy_parser_tree_node(
                                        text = substring( val = input off = index2 len = index2 - index2 )
                                        offset = index2
                                        elements = value #( ) ).
                                    offset = index2.
                                endif.
                                if address6 <> failure_node.
                                    append address6 to elements0.
                                else.
                                    clear elements0.
                                    offset = index1.
                                endif.
                            else.
                                clear elements0.
                                offset = index1.
                            endif.
                        else.
                            clear elements0.
                            offset = index1.
                        endif.
                    else.
                        clear elements0.
                        offset = index1.
                    endif.
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
                address0 = new zcl_url_parser_tree_node1(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_scheme.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'scheme' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'scheme' ] ).
            data(rule) = cache[ key = 'scheme' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'scheme' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 4.
            if max0 <= input_size.
                chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `http`.
                address1 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = offset len = offset + 4 - offset )
                    offset = offset
                    elements = value #( ) ).
                offset = offset + 4.
            else.
                address1 = failure_node.
                if offset > failure.
                    failure = offset.
                endif.
                if offset = failure.
                    append value #( ( `URL::scheme` ) ( `\"http\"` ) ) to expected.
                endif.
            endif.
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index2) = offset.
                data chunk1 type string.
                clear chunk1.
                data(max1) = offset + 1.
                if max1 <= input_size.
                    chunk1 = substring( val = input off = offset len = max1 - offset ).
                endif.
                if chunk1 is not initial and chunk1 = `s`.
                    address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = offset len = offset + 1 - offset )
                        offset = offset
                        elements = value #( ) ).
                    offset = offset + 1.
                else.
                    address2 = failure_node.
                    if offset > failure.
                        failure = offset.
                    endif.
                    if offset = failure.
                        append value #( ( `URL::scheme` ) ( `\"s\"` ) ) to expected.
                    endif.
                endif.
                if address2 = failure_node.
                    address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index2 len = index2 - index2 )
                        offset = index2
                        elements = value #( ) ).
                    offset = index2.
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
                address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_host.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'host' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'host' ] ).
            data(rule) = cache[ key = 'host' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'host' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            address1 = _read_hostname( ).
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index2) = offset.
                address2 = _read_port( ).
                if address2 = failure_node.
                    address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index2 len = index2 - index2 )
                        offset = index2
                        elements = value #( ) ).
                    offset = index2.
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
                address0 = new zcl_url_parser_tree_node2(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_hostname.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'hostname' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'hostname' ] ).
            data(rule) = cache[ key = 'hostname' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'hostname' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            address1 = _read_segment( ).
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
                    data chunk0 type string.
                    clear chunk0.
                    data(max0) = offset + 1.
                    if max0 <= input_size.
                        chunk0 = substring( val = input off = offset len = max0 - offset ).
                    endif.
                    if chunk0 is not initial and chunk0 = `.`.
                        address4 = new zcl_canopy_parser_tree_node(
                            text = substring( val = input off = offset len = offset + 1 - offset )
                            offset = offset
                            elements = value #( ) ).
                        offset = offset + 1.
                    else.
                        address4 = failure_node.
                        if offset > failure.
                            failure = offset.
                        endif.
                        if offset = failure.
                            append value #( ( `URL::hostname` ) ( `\".\"` ) ) to expected.
                        endif.
                    endif.
                    if address4 <> failure_node.
                        append address4 to elements2.
                        data(address5) = failure_node.
                        address5 = _read_segment( ).
                        if address5 <> failure_node.
                            append address5 to elements2.
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
                        address3 = new zcl_url_parser_tree_node4(
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
                address0 = new zcl_url_parser_tree_node3(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_segment.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'segment' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'segment' ] ).
            data(rule) = cache[ key = 'segment' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'segment' value = rule ) to cache.
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
                if chunk0 is not initial and REGEX_1->create_matcher( text = chunk0 )->match( ) = abap_true.
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
                        append value #( ( `URL::segment` ) ( `[a-z0-9-]` ) ) to expected.
                    endif.
                endif.
                if address1 <> failure_node.
                    append address1 to elements0.
                else.
                    exit.
                endif.
            enddo.
            if lines( elements0 ) >= 1.
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

    method _read_port.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'port' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'port' ] ).
            data(rule) = cache[ key = 'port' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'port' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 1.
            if max0 <= input_size.
                chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `:`.
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
                    append value #( ( `URL::port` ) ( `\":\"` ) ) to expected.
                endif.
            endif.
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index2) = offset.
                data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
                clear elements1.
                data address3 type ref to zcl_canopy_parser_tree_node.
                clear address3.
                do.
                    data chunk1 type string.
                    clear chunk1.
                    data(max1) = offset + 1.
                    if max1 <= input_size.
                        chunk1 = substring( val = input off = offset len = max1 - offset ).
                    endif.
                    if chunk1 is not initial and REGEX_2->create_matcher( text = chunk1 )->match( ) = abap_true.
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
                            append value #( ( `URL::port` ) ( `[0-9]` ) ) to expected.
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
                address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_pathname.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'pathname' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'pathname' ] ).
            data(rule) = cache[ key = 'pathname' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'pathname' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 1.
            if max0 <= input_size.
                chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `/`.
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
                    append value #( ( `URL::pathname` ) ( `\"/\"` ) ) to expected.
                endif.
            endif.
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index2) = offset.
                data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
                clear elements1.
                data address3 type ref to zcl_canopy_parser_tree_node.
                clear address3.
                do.
                    data chunk1 type string.
                    clear chunk1.
                    data(max1) = offset + 1.
                    if max1 <= input_size.
                        chunk1 = substring( val = input off = offset len = max1 - offset ).
                    endif.
                    if chunk1 is not initial and REGEX_3->create_matcher( text = chunk1 )->match( ) = abap_true.
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
                            append value #( ( `URL::pathname` ) ( `[^ ?]` ) ) to expected.
                        endif.
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
                address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_search.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'search' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'search' ] ).
            data(rule) = cache[ key = 'search' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'search' value = rule ) to cache.
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
            if chunk0 is not initial and chunk0 = `?`.
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
                    append value #( ( `URL::search` ) ( `\"?\"` ) ) to expected.
                endif.
            endif.
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index3) = offset.
                data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
                clear elements1.
                data address3 type ref to zcl_canopy_parser_tree_node.
                clear address3.
                do.
                    data chunk1 type string.
                    clear chunk1.
                    data(max1) = offset + 1.
                    if max1 <= input_size.
                        chunk1 = substring( val = input off = offset len = max1 - offset ).
                    endif.
                    if chunk1 is not initial and REGEX_4->create_matcher( text = chunk1 )->match( ) = abap_true.
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
                            append value #( ( `URL::search` ) ( `[^ #]` ) ) to expected.
                        endif.
                    endif.
                    if address3 <> failure_node.
                        append address3 to elements1.
                    else.
                        exit.
                    endif.
                enddo.
                if lines( elements1 ) >= 0.
                    address2 = new zcl_canopy_parser_tree_node(
                        text = substring( val = input off = index3 len = offset - index3 )
                        offset = index3
                        elements = elements1 ).
                    offset = offset.
                else.
                    address2 = failure_node.
                endif.
                if address2 <> failure_node.
                    append address2 to elements0.
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
                address0 = new zcl_url_parser_tree_node5(
                    text = substring( val = input off = index2 len = offset - index2 )
                    offset = index2
                    elements = elements0 ).
                offset = offset.
            endif.
            if address0 = failure_node.
                address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = index1 - index1 )
                    offset = index1
                    elements = value #( ) ).
                offset = index1.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

    method _read_hash.
        data(address0) = failure_node.
        data(index0) = offset.
        append value #( key = 'hash' value = value #( ) ) to cache.
        if line_exists( cache[ key = 'hash' ] ).
            data(rule) = cache[ key = 'hash' ]-value.
        endif.
        if rule is initial.
            append value #( key = 'hash' value = rule ) to cache.
        endif.
        if line_exists( rule[ key = offset ] ).
            address0 = rule[ key = offset ]-value->node.
            offset = rule[ key = offset ]-value->tail.
        else.
            data(index1) = offset.
            data elements0 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
            clear elements0.
            data(address1) = failure_node.
            data chunk0 type string.
            clear chunk0.
            data(max0) = offset + 1.
            if max0 <= input_size.
                chunk0 = substring( val = input off = offset len = max0 - offset ).
            endif.
            if chunk0 is not initial and chunk0 = `#`.
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
                    append value #( ( `URL::hash` ) ( `\"#\"` ) ) to expected.
                endif.
            endif.
            if address1 <> failure_node.
                append address1 to elements0.
                data(address2) = failure_node.
                data(index2) = offset.
                data elements1 type zcl_canopy_parser_tree_node=>tree_node_list_tab.
                clear elements1.
                data address3 type ref to zcl_canopy_parser_tree_node.
                clear address3.
                do.
                    data chunk1 type string.
                    clear chunk1.
                    data(max1) = offset + 1.
                    if max1 <= input_size.
                        chunk1 = substring( val = input off = offset len = max1 - offset ).
                    endif.
                    if chunk1 is not initial and REGEX_5->create_matcher( text = chunk1 )->match( ) = abap_true.
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
                            append value #( ( `URL::hash` ) ( `[^ ]` ) ) to expected.
                        endif.
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
                address0 = new zcl_canopy_parser_tree_node(
                    text = substring( val = input off = index1 len = offset - index1 )
                    offset = index1
                    elements = elements0 ).
                offset = offset.
            endif.
            append value #( key = index0 value = new cache_record( node = address0 tail = offset ) ) to rule.
        endif.
        result = address0.
    endmethod.

endclass.
