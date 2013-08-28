#!/bin/sh
#
#  Create a distributable Duktape package into 'dist' directory.  The contents
#  of this directory can then be packaged into a source distributable.
#
#  The distributed source files contain all profiles and variants in one.
#  A developer should be able to use the distributes source as follows:
#
#    1. Add the Duktape source files to their project, whichever build
#       tool they use (make, scons, etc)
#
#    2. Add the Duktape header files to their include path.
#
#    3. Optionally define a DUK_PROFILE (default profile is used otherwise).
#
#    4. Compile their program (which uses Duktape API).
#
#  In addition to sources, documentation, example programs, an example
#  Makefile, and test cases are packaged into the dist package.
#

DIST=`pwd`/dist
DISTSRCSEP=$DIST/src-separate
DISTSRCCOM=$DIST/src-combined
DISTFILE=duktape-dist.tar.xz

# FIXME
BUILDINFO="`date +%Y-%m-%d`; `uname -a`; `git rev-parse HEAD`"
DUK_VERSION=1

echo "Creating distributable sources to: $DIST"

# Create dist directory structure

rm -rf $DIST
mkdir $DIST
mkdir $DIST/src-separate
mkdir $DIST/src-combined
mkdir $DIST/doc
#mkdir $DIST/runtests
#mkdir $DIST/ecmascript-testcases
#mkdir $DIST/api-testcases
mkdir $DIST/examples
mkdir $DIST/examples/hello
mkdir $DIST/examples/cmdline

# Copy most files directly

for i in	\
	duk_alloc_default.c	\
	duk_alloc_torture.c	\
	duk_api_buffer.c	\
	duk_api.c		\
	duk_api_call.c		\
	duk_api_codec.c		\
	duk_api_compile.c	\
	duktape.h		\
	duk_api_internal.h	\
	duk_api_memory.c	\
	duk_api_object.c	\
	duk_api_string.c	\
	duk_api_thread.c	\
	duk_api_var.c		\
	duk_bittypes.h		\
	duk_builtin_array.c	\
	duk_builtin_boolean.c	\
	duk_builtin_date.c	\
	duk_builtin_duk.c	\
	duk_builtin_error.c	\
	duk_builtin_function.c	\
	duk_builtin_global.c	\
	duk_builtin_json.c	\
	duk_builtin_math.c	\
	duk_builtin_number.c	\
	duk_builtin_object.c	\
	duk_builtin_protos.h	\
	duk_builtin_regexp.c	\
	duk_builtin_string.c	\
	duk_builtin_thread.c	\
	duk_builtin_thrower.c	\
	duk_debug_fixedbuffer.c	\
	duk_debug.h		\
	duk_debug_heap.c	\
	duk_debug_hobject.c	\
	duk_debug_macros.c	\
	duk_debug_vsnprintf.c	\
	duk_error_augment.c	\
	duk_error_fatal.c	\
	duk_error.h		\
	duk_error_longjmp.c	\
	duk_error_macros.c	\
	duk_error_misc.c	\
	duk_error_throw.c	\
	duk_features.h		\
	duk_forwdecl.h		\
	duk_hbuffer_alloc.c	\
	duk_hbuffer.h		\
	duk_hbuffer_ops.c	\
	duk_hcompiledfunction.h	\
	duk_heap_alloc.c	\
	duk_heap.h		\
	duk_heap_hashstring.c	\
	duk_heaphdr.h		\
	duk_heap_markandsweep.c	\
	duk_heap_memory.c	\
	duk_heap_misc.c		\
	duk_heap_refcount.c	\
	duk_heap_stringcache.c	\
	duk_heap_stringtable.c	\
	duk_hnativefunction.h	\
	duk_hobject_alloc.c	\
	duk_hobject_class.c	\
	duk_hobject_enum.c	\
	duk_hobject_finalizer.c	\
	duk_hobject.h		\
	duk_hobject_misc.c	\
	duk_hobject_pc2line.c	\
	duk_hobject_props.c	\
	duk_hstring.h		\
	duk_hthread_alloc.c	\
	duk_hthread_builtins.c	\
	duk_hthread.h		\
	duk_hthread_misc.c	\
	duk_hthread_stacks.c	\
	duk_internal.h		\
	duk_jmpbuf.h		\
	duk_js_bytecode.h	\
	duk_js_call.c		\
	duk_js_compiler.c	\
	duk_js_compiler.h	\
	duk_js_executor.c	\
	duk_js.h		\
	duk_json.h		\
	duk_js_ops.c		\
	duk_js_var.c		\
	duk_lexer.c		\
	duk_lexer.h		\
	duk_misc.h		\
	duk_numconv.c		\
	duk_numconv.h		\
	duk_rdtsc.h		\
	duk_regexp_compiler.c	\
	duk_regexp_executor.c	\
	duk_regexp.h		\
	duk_tval.h		\
	duk_unicode.h		\
	duk_unicode_support.c	\
	duk_unicode_tables.c	\
	duk_util_bitdecoder.c	\
	duk_util_bitencoder.c	\
	duk_util.h		\
	duk_util_hashbytes.c	\
	duk_util_hashprime.c	\
	duk_util_misc.c		\
	duk_util_tinyrandom.c	\
	; do
	cp src/$i $DISTSRCSEP/
done

for i in \
	duk_cmdline.c \
	duk_ncurses.c \
	duk_socket.c \
	duk_fileio.c \
	; do
	cp examples/cmdline/$i $DIST/examples/cmdline/
done

for i in \
	hello.c \
	; do
	cp examples/hello/$i $DIST/examples/hello/
done

for i in \
	Makefile.example \
	; do
	cp examples/$i $DIST/
done

cp README.txt.dist $DIST/README.txt
cp LICENSE.txt $DIST/LICENSE.txt

# FIXME: web docs?

# Testcases and internal documentation is not included

#for i in \
#	runtests.js \
#	package.json \
#	; do
#	cp runtests/$i $DIST/runtests/
#done

#for i in ecmascript-testcases/*.js \
#	; do
#	cp $i $DIST/ecmascript-testcases/
#done

#for i in api-testcases/*.js \
#	; do
#	cp $i $DIST/api-testcases/
#done

#for i in \
#	datetime.txt \
#	regexp.txt \
#	json.txt \
#	sorting.txt \
#	number_conversion.txt \
#	; do
#	cp doc/$i $DIST/doc
#done

# Autogenerated strings and built-in files
#
# There are currently no profile specific variants of strings/builtins, but
# this will probably change when functions are added/removed based on profile.

# FIXME: byte order

python src/genbuildparams.py \
	--version=$DUK_VERSION \
	--build="$BUILDINFO" \
	--out-json=$DISTSRCSEP/buildparams.json.tmp \
	--out-header=$DISTSRCSEP/duk_buildparams.h.tmp

python src/genstrings.py \
	--byte-order=little \
	--out-header=$DISTSRCSEP/duk_strings_little.h.tmp \
	--out-source=$DISTSRCSEP/duk_strings_little.c.tmp \
	--out-python=$DISTSRCSEP/duk_strings_little.py.tmp \
	--out-bin=$DISTSRCSEP/duk_strings_little.bin.tmp

python src/genbuiltins.py \
	--buildinfo=$DISTSRCSEP/buildparams.json.tmp \
	--byte-order=little \
	--strings-py=$DISTSRCSEP/duk_strings_little.py.tmp \
	--out-header=$DISTSRCSEP/duk_builtins_little.h.tmp \
	--out-source=$DISTSRCSEP/duk_builtins_little.c.tmp \
	--out-bin=$DISTSRCSEP/duk_builtins_little.bin.tmp

# Autogenerated Unicode files
#
# Note: not all of the generated headers are used.  For instance, the
# match table for "WhiteSpace-Z" is not used, because a custom piece
# of code handles that particular match.
#
# For IDPART:
#   UnicodeCombiningMark -> categories Mn, Mc
#   UnicodeDigit -> categories Nd
#   UnicodeConnectorPunctuation -> categories Pc

IDSTART_NOASCII_INCL='Lu,Ll,Lt,Lm,Lo,Nl,0024,005F'
IDSTART_NOASCII_EXCL='ASCII'
IDSTART_NOASCII_BMPONLY_INCL=$IDSTART_NOASCII_INCL
IDSTART_NOASCII_BMPONLY_EXCL='ASCII,NONBMP'
IDPART_MINUS_IDSTART_NOASCII_INCL='Lu,Ll,Lt,Lm,Lo,Nl,0024,005F,Mn,Mc,Nd,Pc,200C,200D'
IDPART_MINUS_IDSTART_NOASCII_EXCL='Lu,Ll,Lt,Lm,Lo,Nl,0024,005F,ASCII'
IDPART_MINUS_IDSTART_NOASCII_BMPONLY_INCL=$IDPART_MINUS_IDSTART_NOASCII_INCL
IDPART_MINUS_IDSTART_NOASCII_BMPONLY_EXCL='Lu,Ll,Lt,Lm,Lo,Nl,0024,005F,ASCII,NONBMP'

# FIXME: name?
python src/extract_chars.py \
	--unicode-data=src/UnicodeData.txt \
	--include-categories=Z \
	--out-source=$DISTSRCSEP/duk_unicode_ws_m_z.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_ws_m_z.h.tmp \
	--table-name=duk_unicode_whitespace_minus_z \
	> $DISTSRCSEP/WhiteSpace-Z.txt

# E5 Section 7.6
python src/extract_chars.py \
	--unicode-data=src/UnicodeData.txt \
	--include-categories=$IDSTART_NOASCII_INCL \
	--exclude-categories=$IDSTART_NOASCII_EXCL \
	--out-source=$DISTSRCSEP/duk_unicode_ids_noa.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_ids_noa.h.tmp \
	--table-name=duk_unicode_identifier_start_noascii \
	> $DISTSRCSEP/IdentifierStart-noascii.txt

python src/extract_chars.py \
	--unicode-data=src/UnicodeData.txt \
	--include-categories=$IDSTART_NOASCII_BMPONLY_INCL \
	--exclude-categories=$IDSTART_NOASCII_BMPONLY_EXCL \
	--out-source=$DISTSRCSEP/duk_unicode_ids_noa_bmpo.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_ids_noa_bmpo.h.tmp \
	--table-name=duk_unicode_identifier_start_noascii_bmponly \
	> $DISTSRCSEP/IdentifierStart-noascii-bmponly.txt

#t_uni_idstart_noascii_png = \
#	env.Command(['IdentifierStart-noascii.png'],
#	            ['UnicodeData.txt'],
#	            'python src/extract_chars.py --unicode-data=${SOURCES[0]} --include-categories=%s --exclude-categories=%s --out-png=${TARGETS[0]} > /dev/null' % \
#	            (IDSTART_NOASCII_INCL, IDSTART_NOASCII_EXCL))
#t_uni_idstart_noascii_bmponly_png = \
#	env.Command(['IdentifierStart-noascii-bmponly.png'],
#	            ['UnicodeData.txt'],
#	            'python src/extract_chars.py --unicode-data=${SOURCES[0]} --include-categories=%s --exclude-categories=%s --out-png=${TARGETS[0]} > /dev/null' % \
#	            (IDSTART_NOASCII_BMPONLY_INCL, IDSTART_NOASCII_BMPONLY_EXCL))

# E5 Section 7.6: IdentifierPart, but remove IdentifierStart (already above)
python src/extract_chars.py \
	--unicode-data=src/UnicodeData.txt \
	--include-categories=$IDPART_MINUS_IDSTART_NOASCII_INCL \
	--exclude-categories=$IDPART_MINUS_IDSTART_NOASCII_EXCL \
	--out-source=$DISTSRCSEP/duk_unicode_idp_m_ids_noa.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_idp_m_ids_noa.h.tmp \
	--table-name=duk_unicode_identifier_part_minus_identifier_start_noascii \
	> $DISTSRCSEP/IdentifierPart-minus-IdentifierStart-noascii.txt

python src/extract_chars.py \
	--unicode-data=src/UnicodeData.txt \
	--include-categories=$IDPART_MINUS_IDSTART_NOASCII_BMPONLY_INCL \
	--exclude-categories=$IDPART_MINUS_IDSTART_NOASCII_BMPONLY_EXCL \
	--out-source=$DISTSRCSEP/duk_unicode_idp_m_ids_noa_bmpo.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_idp_m_ids_noa_bmpo.h.tmp \
	--table-name=duk_unicode_identifier_part_minus_identifier_start_noascii_bmponly \
	> $DISTSRCSEP/IdentifierPart-minus-IdentifierStart-noascii-bmponly.txt

#t_uni_idpart_minus_idstart_noascii_png = \
#	env.Command(['IdentifierPart-minus-IdentifierStart-noascii.png'],
#	            ['UnicodeData.txt'],
#	            'python src/extract_chars.py --unicode-data=${SOURCES[0]} --include-categories=%s --exclude-categories=%s --out-png=${TARGETS[0]} > /dev/null' % \
#	            (IDPART_MINUS_IDSTART_NOASCII_INCL, IDPART_MINUS_IDSTART_NOASCII_EXCL))
#t_uni_idpart_minus_idstart_noascii_bmponly_png = \
#	env.Command(['IdentifierPart-minus-IdentifierStart-noascii-bmponly.png'],
#	            ['UnicodeData.txt'],
#	            'python src/extract_chars.py --unicode-data=${SOURCES[0]} --include-categories=%s --exclude-categories=%s --out-png=${TARGETS[0]} > /dev/null' % \
#	            (IDPART_MINUS_IDSTART_NOASCII_BMPONLY_INCL, IDPART_MINUS_IDSTART_NOASCII_BMPONLY_EXCL))

python src/extract_caseconv.py \
	--unicode-data=src/UnicodeData.txt \
	--special-casing=src/SpecialCasing.txt \
	--out-source=$DISTSRCSEP/duk_unicode_caseconv.c.tmp \
	--out-header=$DISTSRCSEP/duk_unicode_caseconv.h.tmp \
	--table-name-lc=duk_unicode_caseconv_lc \
	--table-name-uc=duk_unicode_caseconv_uc \
	> $DISTSRCSEP/CaseConversion.txt

# Inject autogenerated files into source and header files so that they are
# usable (for all profiles and define cases) directly.
#
# The injection points use a standard C preprocessor #include syntax
# (earlier these were actual includes).

cat > $DISTSRCSEP/sed.tmp <<EOF
/#include "duk_unicode_ids_noa.h"/ {
	r $DISTSRCSEP/duk_unicode_ids_noa.h.tmp
	d
}
/#include "duk_unicode_ids_noa_bmpo.h"/ {
	r $DISTSRCSEP/duk_unicode_ids_noa_bmpo.h.tmp
	d
}
/#include "duk_unicode_idp_m_ids_noa.h"/ {
	r $DISTSRCSEP/duk_unicode_idp_m_ids_noa.h.tmp
	d
}
/#include "duk_unicode_idp_m_ids_noa_bmpo.h"/ {
	r $DISTSRCSEP/duk_unicode_idp_m_ids_noa_bmpo.h.tmp
	d
}
/#include "duk_unicode_caseconv.h"/ {
	r $DISTSRCSEP/duk_unicode_caseconv.h.tmp
	d
}
EOF

mv $DISTSRCSEP/duk_unicode.h $DISTSRCSEP/duk_unicode.h.tmp
sed -f $DISTSRCSEP/sed.tmp $DISTSRCSEP/duk_unicode.h.tmp > $DISTSRCSEP/duk_unicode.h
rm $DISTSRCSEP/sed.tmp
rm $DISTSRCSEP/duk_unicode.h.tmp

cat > $DISTSRCSEP/sed.tmp <<EOF
/#include "duk_unicode_ids_noa.c"/ {
	r $DISTSRCSEP/duk_unicode_ids_noa.c.tmp
	d
}
/#include "duk_unicode_ids_noa_bmpo.c"/ {
	r $DISTSRCSEP/duk_unicode_ids_noa_bmpo.c.tmp
	d
}
/#include "duk_unicode_idp_m_ids_noa.c"/ {
	r $DISTSRCSEP/duk_unicode_idp_m_ids_noa.c.tmp
	d
}
/#include "duk_unicode_idp_m_ids_noa_bmpo.c"/ {
	r $DISTSRCSEP/duk_unicode_idp_m_ids_noa_bmpo.c.tmp
	d
}
/#include "duk_unicode_caseconv.c"/ {
	r $DISTSRCSEP/duk_unicode_caseconv.c.tmp
	d
}
EOF

mv $DISTSRCSEP/duk_unicode_tables.c $DISTSRCSEP/duk_unicode_tables.c.tmp
sed -f $DISTSRCSEP/sed.tmp $DISTSRCSEP/duk_unicode_tables.c.tmp > $DISTSRCSEP/duk_unicode_tables.c
rm $DISTSRCSEP/sed.tmp
rm $DISTSRCSEP/duk_unicode_tables.c.tmp

# FIXME: endian variants
mv $DISTSRCSEP/duk_strings_little.c.tmp $DISTSRCSEP/duk_strings.c
mv $DISTSRCSEP/duk_strings_little.h.tmp $DISTSRCSEP/duk_strings.h
mv $DISTSRCSEP/duk_builtins_little.c.tmp $DISTSRCSEP/duk_builtins.c
mv $DISTSRCSEP/duk_builtins_little.h.tmp $DISTSRCSEP/duk_builtins.h

# Clean up sources: after this step only relevant files should remain

rm $DISTSRCSEP/*.tmp
rm $DISTSRCSEP/*.tmpc  # python compiled file
rm $DISTSRCSEP/WhiteSpace-Z.txt
rm $DISTSRCSEP/IdentifierStart-noascii.txt
rm $DISTSRCSEP/IdentifierStart-noascii-bmponly.txt
rm $DISTSRCSEP/IdentifierPart-minus-IdentifierStart-noascii.txt
rm $DISTSRCSEP/IdentifierPart-minus-IdentifierStart-noascii-bmponly.txt
rm $DISTSRCSEP/CaseConversion.txt

# Create a combined source file, duktape.c, into a separate combined source
# directory.  This allows user to just include "duktape.c" and "duktape.h"
# into a project and maximizes inlining and size optimization opportunities
# even with older compilers.  The resulting duktape.c is quite ugly though.

python combine_src.py $DISTSRCSEP $DISTSRCCOM/duktape.c
cp $DISTSRCSEP/duktape.h $DISTSRCCOM/duktape.h

# Final cleanup
# nothing now

