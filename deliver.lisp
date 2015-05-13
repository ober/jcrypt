(load "load.lisp")

#+(or ccl clisp sbcl)
(ql:quickload "trivial-dump-core")

#+sbcl
(sb-ext:save-lisp-and-die "main-sbcl" :compression 9 :executable t :toplevel 'jcrypt::main :save-runtime-options t)

#+(or ccl clisp)
(trivial-dump-core:save-executable "jcrypt" #'jcrypt::main)

#+lispworks
(deliver 'jcrypt::main "jcrypt" 1 :multiprocessing t :keep-eval t)
