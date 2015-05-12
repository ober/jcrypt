(load "load.lisp")

#+(or ccl clisp sbcl)
(ql:quickload "trivial-dump-core")

;; #+sbcl
;; (sb-ext:save-lisp-and-die "main-sbcl" :executable t :toplevel 'ctcl::main :save-runtime-options t)

#+(or ccl clisp sbcl)
(trivial-dump-core:save-executable "jcrypt" #'jcrypt::main)

#+lispworks
(deliver 'jcrypt::main "jcrypt" 1 :multiprocessing t :keep-eval t)
