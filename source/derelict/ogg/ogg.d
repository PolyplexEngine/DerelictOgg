/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.ogg.ogg;

private {
    import core.stdc.config;
    import derelict.util.loader;
    import derelict.util.system;

    static if( Derelict_OS_Windows )
        enum libNames = "ogg.dll, libogg-0.dll, libogg.dll";
    else static if( Derelict_OS_Mac )
        enum libNames = "libogg.dylib, libogg.0.dylib";
    else static if( Derelict_OS_Posix )
        enum libNames = "libogg.so, libogg.so.0";
    else
        static assert( 0, "Need to implement libogg libnames for this operating system." );
}

alias ogg_int64_t = long;
alias ogg_uint64_t = ulong;
alias ogg_int32_t = int;
alias ogg_uint32_t = uint;
alias ogg_int16_t = short;
alias ogg_uint16_t = ushort;

struct ogg_iovec_t {
    void* iov_base;
    size_t iov_len;
}

struct oggpack_buffer {
    c_long endbyte;
    int endbit;
    ubyte* buffer;
    ubyte* ptr;
    c_long storage;
}

struct ogg_page {
    ubyte* header;
    c_long header_len;
    ubyte* _body;       // originally named "body", but that's a keyword in D.
    c_long body_len;
}

struct ogg_stream_state {
    ubyte* body_data;
    c_long body_storage;
    c_long body_fill;
    c_long body_returned;
    int* lacing_vals;
    ogg_int64_t* granule_vals;
    c_long lacing_storage;
    c_long lacing_fill;
    c_long lacing_packet;
    c_long lacing_returned;
    ubyte[282] header;
    int header_fill;
    int e_o_s;
    int b_o_s;
    c_long serialno;
    c_long pageno;
    ogg_int64_t packetno;
    ogg_int64_t granulepos;
}

struct ogg_packet {
    ubyte* packet;
    c_long bytes;
    c_long b_o_s;
    c_long e_o_s;
    ogg_int64_t granulepos;
    ogg_int64_t packetno;
}

struct ogg_sync_state {
    ubyte* data;
    int storage;
    int fill;
    int returned;

    int unsynced;
    int headerbytes;
    int bodybytes;
}

extern( C ) {
    alias da_oggpack_writeinit = void function( oggpack_buffer* );
    alias da_oggpack_writecheck = void function( oggpack_buffer* );
    alias da_oggpack_writetrunc = void function( oggpack_buffer*, c_long );
    alias da_oggpack_writealign = void function( oggpack_buffer* );
    alias da_oggpack_writecopy = void function( oggpack_buffer*, void*, c_long );
    alias da_oggpack_reset = void function( oggpack_buffer* );
    alias da_oggpack_writeclear = void function( oggpack_buffer* );
    alias da_oggpack_readinit = void function( oggpack_buffer*, ubyte*, int );
    alias da_oggpack_write = void function( oggpack_buffer*, c_ulong, int );
    alias da_oggpack_look = c_long function( oggpack_buffer*, int );
    alias da_oggpack_look1 = c_long function( oggpack_buffer* );
    alias da_oggpack_adv = void function( oggpack_buffer*, int );
    alias da_oggpack_adv1 = void function( oggpack_buffer* );
    alias da_oggpack_read = c_long function( oggpack_buffer*, int );
    alias da_oggpack_read1 = c_long function( oggpack_buffer* );
    alias da_oggpack_bytes = c_long function( oggpack_buffer* );
    alias da_oggpack_bits = c_long function( oggpack_buffer* );
    alias da_oggpack_get_buffer = ubyte function( oggpack_buffer* );
    alias da_oggpackB_writeinit = void function( oggpack_buffer* );
    alias da_oggpackB_writecheck = void function( oggpack_buffer* );
    alias da_oggpackB_writetrunc = void function( oggpack_buffer*, c_long  );
    alias da_oggpackB_writealign = void function( oggpack_buffer* );
    alias da_oggpackB_writecopy = void function( oggpack_buffer*, void*, c_long );
    alias da_oggpackB_reset = void function( oggpack_buffer* );
    alias da_oggpackB_writeclear = void function( oggpack_buffer* );
    alias da_oggpackB_readinit = void function( oggpack_buffer*, ubyte*, int );
    alias da_oggpackB_write = void function( oggpack_buffer*, uint, c_long );
    alias da_oggpackB_look = c_long function( oggpack_buffer*, int );
    alias da_oggpackB_look1 = c_long function( oggpack_buffer* );
    alias da_oggpackB_adv = void function( oggpack_buffer*, int );
    alias da_oggpackB_adv1 = void function( oggpack_buffer* );
    alias da_oggpackB_read = c_long function( oggpack_buffer*, int );
    alias da_oggpackB_read1 = c_long function( oggpack_buffer* );
    alias da_oggpackB_bytes = c_long function( oggpack_buffer* );
    alias da_oggpackB_bits = c_long function( oggpack_buffer* );
    alias da_oggpackB_get_buffer = ubyte function( oggpack_buffer* );
    alias da_ogg_stream_packetin = int function( ogg_stream_state*, ogg_packet* );
    alias da_ogg_stream_iovecin = int function( ogg_stream_state*, ogg_iovec_t*, int, c_long, ogg_int64_t );
    alias da_ogg_stream_pageout = int function( ogg_stream_state*, ogg_page* );
    alias da_ogg_stream_pageout_fill = int function( ogg_stream_state*, ogg_page*, int );
    alias da_ogg_stream_flush = int function( ogg_stream_state*, ogg_page* );
    alias da_ogg_stream_flush_fill = int function( ogg_stream_state*, ogg_page* );
    alias da_ogg_sync_init = int function( ogg_sync_state* );
    alias da_ogg_sync_clear = int function( ogg_sync_state* );
    alias da_ogg_sync_reset = int function( ogg_sync_state* );
    alias da_ogg_sync_destroy = int function( ogg_sync_state* );
    alias da_ogg_sync_check = int function( ogg_sync_state* );
    alias da_ogg_sync_buffer = byte* function( ogg_sync_state*, c_long );
    alias da_ogg_sync_wrote = int function( ogg_sync_state*, c_long );
    alias da_ogg_sync_pageseek = c_long function( ogg_sync_state*,ogg_page* );
    alias da_ogg_sync_pageout = int function( ogg_sync_state*, ogg_page* );
    alias da_ogg_stream_pagein = int function( ogg_stream_state*, ogg_page* );
    alias da_ogg_stream_packetout = int function( ogg_stream_state*,ogg_packet* );
    alias da_ogg_stream_packetpeek = int function( ogg_stream_state*,ogg_packet* );
    alias da_ogg_stream_init = int function( ogg_stream_state*,int serialno );
    alias da_ogg_stream_clear = int function( ogg_stream_state* );
    alias da_ogg_stream_reset = int function( ogg_stream_state* );
    alias da_ogg_stream_reset_serialno = int function( ogg_stream_state*,int serialno );
    alias da_ogg_stream_destroy = int function( ogg_stream_state* );
    alias da_ogg_stream_check = int function( ogg_stream_state* );
    alias da_ogg_stream_eos = int function( ogg_stream_state* );
    alias da_ogg_page_checksum_set = void function( ogg_page* );
    alias da_ogg_page_version = int function( ogg_page* );
    alias da_ogg_page_continued = int function( ogg_page* );
    alias da_ogg_page_bos = int function( ogg_page* );
    alias da_ogg_page_eos = int function( ogg_page* );
    alias da_ogg_page_granulepos = ogg_int64_t function( ogg_page* );
    alias da_ogg_page_serialno = int function( ogg_page* );
    alias da_ogg_page_pageno = c_long function( ogg_page* );
    alias da_ogg_page_packets = int function( ogg_page* );
    alias da_ogg_packet_clear = void function( ogg_packet* );
}

__gshared {
    da_oggpack_writeinit oggpack_writeinit;
    da_oggpack_writecheck oggpack_writecheck;
    da_oggpack_writetrunc oggpack_writetrunc;
    da_oggpack_writealign oggpack_writealign;
    da_oggpack_writecopy oggpack_writecopy;
    da_oggpack_reset oggpack_reset;
    da_oggpack_writeclear oggpack_writeclear;
    da_oggpack_readinit oggpack_readinit;
    da_oggpack_write oggpack_write;
    da_oggpack_look oggpack_look;
    da_oggpack_look1 oggpack_look1;
    da_oggpack_adv oggpack_adv;
    da_oggpack_adv1 oggpack_adv1;
    da_oggpack_read oggpack_read;
    da_oggpack_read1 oggpack_read1;
    da_oggpack_bytes oggpack_bytes;
    da_oggpack_bits oggpack_bits;
    da_oggpack_get_buffer oggpack_get_buffer;
    da_oggpackB_writeinit oggpackB_writeinit;
    da_oggpackB_writecheck oggpackB_writecheck;
    da_oggpackB_writetrunc oggpackB_writetrunc;
    da_oggpackB_writealign oggpackB_writealign;
    da_oggpackB_writecopy oggpackB_writecopy;
    da_oggpackB_reset oggpackB_reset;
    da_oggpackB_writeclear oggpackB_writeclear;
    da_oggpackB_readinit oggpackB_readinit;
    da_oggpackB_write oggpackB_write;
    da_oggpackB_look oggpackB_look;
    da_oggpackB_look1 oggpackB_look1;
    da_oggpackB_adv oggpackB_adv;
    da_oggpackB_adv1 oggpackB_adv1;
    da_oggpackB_read oggpackB_read;
    da_oggpackB_read1 oggpackB_read1;
    da_oggpackB_bytes oggpackB_bytes;
    da_oggpackB_bits oggpackB_bits;
    da_oggpackB_get_buffer oggpackB_get_buffer;
    da_ogg_stream_packetin ogg_stream_packetin;
    da_ogg_stream_iovecin ogg_stream_iovecin;
    da_ogg_stream_pageout ogg_stream_pageout;
    da_ogg_stream_pageout_fill ogg_stream_pageout_fill;
    da_ogg_stream_flush ogg_stream_flush;
    da_ogg_stream_flush_fill ogg_stream_flush_fill;
    da_ogg_sync_init ogg_sync_init;
    da_ogg_sync_clear ogg_sync_clear;
    da_ogg_sync_reset ogg_sync_reset;
    da_ogg_sync_destroy ogg_sync_destroy;
    da_ogg_sync_check ogg_sync_check;
    da_ogg_sync_buffer ogg_sync_buffer;
    da_ogg_sync_wrote ogg_sync_wrote;
    da_ogg_sync_pageseek ogg_sync_pageseek;
    da_ogg_sync_pageout ogg_sync_pageout;
    da_ogg_stream_pagein ogg_stream_pagein;
    da_ogg_stream_packetout ogg_stream_packetout;
    da_ogg_stream_packetpeek ogg_stream_packetpeek;
    da_ogg_stream_init ogg_stream_init;
    da_ogg_stream_clear ogg_stream_clear;
    da_ogg_stream_reset ogg_stream_reset;
    da_ogg_stream_reset_serialno ogg_stream_reset_serialno;
    da_ogg_stream_destroy ogg_stream_destroy;
    da_ogg_stream_check ogg_stream_check;
    da_ogg_stream_eos ogg_stream_eos;
    da_ogg_page_checksum_set ogg_page_checksum_set;
    da_ogg_page_version ogg_page_version;
    da_ogg_page_continued ogg_page_continued;
    da_ogg_page_bos ogg_page_bos;
    da_ogg_page_eos ogg_page_eos;
    da_ogg_page_granulepos ogg_page_granulepos;
    da_ogg_page_serialno ogg_page_serialno;
    da_ogg_page_pageno ogg_page_pageno;
    da_ogg_page_packets ogg_page_packets;
    da_ogg_packet_clear ogg_packet_clear;
}

class DerelictOggLoader : SharedLibLoader {
    public this() {
        super( libNames );
    }

    protected override void loadSymbols() {
        bindFunc( cast( void** )&oggpack_writeinit, "oggpack_writeinit" );
        bindFunc( cast( void** )&oggpack_writecheck, "oggpack_writecheck" );
        bindFunc( cast( void** )&oggpack_writetrunc, "oggpack_writetrunc" );
        bindFunc( cast( void** )&oggpack_writealign, "oggpack_writealign" );
        bindFunc( cast( void** )&oggpack_writecopy, "oggpack_writecopy" );
        bindFunc( cast( void** )&oggpack_reset, "oggpack_reset" );
        bindFunc( cast( void** )&oggpack_writeclear, "oggpack_writeclear" );
        bindFunc( cast( void** )&oggpack_readinit, "oggpack_readinit" );
        bindFunc( cast( void** )&oggpack_write, "oggpack_write" );
        bindFunc( cast( void** )&oggpack_look, "oggpack_look" );
        bindFunc( cast( void** )&oggpack_look1, "oggpack_look1" );
        bindFunc( cast( void** )&oggpack_adv, "oggpack_adv" );
        bindFunc( cast( void** )&oggpack_adv1, "oggpack_adv1" );
        bindFunc( cast( void** )&oggpack_read, "oggpack_read" );
        bindFunc( cast( void** )&oggpack_read1, "oggpack_read1" );
        bindFunc( cast( void** )&oggpack_bytes, "oggpack_bytes" );
        bindFunc( cast( void** )&oggpack_bits, "oggpack_bits" );
        bindFunc( cast( void** )&oggpack_get_buffer, "oggpack_get_buffer" );

        bindFunc( cast( void** )&oggpackB_writeinit, "oggpackB_writeinit" );
        bindFunc( cast( void** )&oggpackB_writecheck, "oggpackB_writecheck" );
        bindFunc( cast( void** )&oggpackB_writetrunc, "oggpackB_writetrunc" );
        bindFunc( cast( void** )&oggpackB_writealign, "oggpackB_writealign" );
        bindFunc( cast( void** )&oggpackB_writecopy, "oggpackB_writecopy" );
        bindFunc( cast( void** )&oggpackB_reset, "oggpackB_reset" );
        bindFunc( cast( void** )&oggpackB_writeclear, "oggpackB_writeclear" );
        bindFunc( cast( void** )&oggpackB_readinit, "oggpackB_readinit" );
        bindFunc( cast( void** )&oggpackB_write, "oggpackB_write" );
        bindFunc( cast( void** )&oggpackB_look, "oggpackB_look" );
        bindFunc( cast( void** )&oggpackB_look1, "oggpackB_look1" );
        bindFunc( cast( void** )&oggpackB_adv, "oggpackB_adv" );
        bindFunc( cast( void** )&oggpackB_adv1, "oggpackB_adv1" );
        bindFunc( cast( void** )&oggpackB_read, "oggpackB_read" );
        bindFunc( cast( void** )&oggpackB_read1, "oggpackB_read1" );
        bindFunc( cast( void** )&oggpackB_bytes, "oggpackB_bytes" );
        bindFunc( cast( void** )&oggpackB_bits, "oggpackB_bits" );
        bindFunc( cast( void** )&oggpackB_get_buffer, "oggpackB_get_buffer" );

        bindFunc( cast( void** )&ogg_stream_packetin, "ogg_stream_packetin" );
        bindFunc( cast( void** )&ogg_stream_iovecin, "ogg_stream_iovecin" );
        bindFunc( cast( void** )&ogg_stream_pageout, "ogg_stream_pageout" );
        bindFunc( cast( void** )&ogg_stream_pageout_fill, "ogg_stream_pageout_fill" );
        bindFunc( cast( void** )&ogg_stream_flush, "ogg_stream_flush" );
        bindFunc( cast( void** )&ogg_stream_flush_fill, "ogg_stream_flush_fill" );

        bindFunc( cast( void** )&ogg_sync_init, "ogg_sync_init" );
        bindFunc( cast( void** )&ogg_sync_clear, "ogg_sync_clear" );
        bindFunc( cast( void** )&ogg_sync_reset, "ogg_sync_reset" );
        bindFunc( cast( void** )&ogg_sync_destroy, "ogg_sync_destroy" );
        bindFunc( cast( void** )&ogg_sync_check, "ogg_sync_check" );

        bindFunc( cast( void** )&ogg_sync_buffer, "ogg_sync_buffer" );
        bindFunc( cast( void** )&ogg_sync_wrote, "ogg_sync_wrote" );
        bindFunc( cast( void** )&ogg_sync_pageseek, "ogg_sync_pageseek" );
        bindFunc( cast( void** )&ogg_sync_pageout, "ogg_sync_pageout" );
        bindFunc( cast( void** )&ogg_stream_pagein, "ogg_stream_pagein" );
        bindFunc( cast( void** )&ogg_stream_packetout, "ogg_stream_packetout" );
        bindFunc( cast( void** )&ogg_stream_packetpeek, "ogg_stream_packetpeek" );

        bindFunc( cast( void** )&ogg_stream_init, "ogg_stream_init" );
        bindFunc( cast( void** )&ogg_stream_clear, "ogg_stream_clear" );
        bindFunc( cast( void** )&ogg_stream_reset, "ogg_stream_reset" );
        bindFunc( cast( void** )&ogg_stream_reset_serialno, "ogg_stream_reset_serialno" );
        bindFunc( cast( void** )&ogg_stream_destroy, "ogg_stream_destroy" );
        bindFunc( cast( void** )&ogg_stream_check, "ogg_stream_check" );
        bindFunc( cast( void** )&ogg_stream_eos, "ogg_stream_eos" );

        bindFunc( cast( void** )&ogg_page_checksum_set, "ogg_page_checksum_set" );
        bindFunc( cast( void** )&ogg_page_version, "ogg_page_version" );
        bindFunc( cast( void** )&ogg_page_continued, "ogg_page_continued" );
        bindFunc( cast( void** )&ogg_page_bos, "ogg_page_bos" );
        bindFunc( cast( void** )&ogg_page_eos, "ogg_page_eos" );
        bindFunc( cast( void** )&ogg_page_granulepos, "ogg_page_granulepos" );
        bindFunc( cast( void** )&ogg_page_serialno, "ogg_page_serialno" );
        bindFunc( cast( void** )&ogg_page_pageno, "ogg_page_pageno" );
        bindFunc( cast( void** )&ogg_page_packets, "ogg_page_packets" );
        bindFunc( cast( void** )&ogg_packet_clear, "ogg_packet_clear" );
    }
}

__gshared DerelictOggLoader DerelictOgg;

static this() {
    if( DerelictOgg is null ) {
        DerelictOgg = new DerelictOggLoader();
    }
}