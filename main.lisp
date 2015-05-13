(in-package :jcrypt)

(defun argv ()
  (or
   #+clisp (ext:argv)
   #+sbcl sb-ext:*posix-argv*
   #+abcl ext:*command-line-argument-list*
   #+clozure (ccl::command-line-arguments)
   #+gcl si:*command-args*
   #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
   #+cmu extensions:*command-line-strings*
   #+allegro (sys:command-line-arguments)
   #+lispworks sys:*line-arguments-list*
   nil))

(defun usage (app)
  (format t "Usage: ~A <encrypt|decrypt|gen-new-iv> <input file> <passphrase> <output file>~%" app))

(defun main ()
  (let* ((args (argv))
	 (verb (nth 1 args)))
	 ;; (inputfile (nth 2 args))
    	 ;; (passphrase (nth 3 args))
	 ;; (outputfile (nth 4 args)))
    (cond
      ((equal "encrypt" verb) (wank-encrypt-file (ngth 2 args) (nth 3 args) (nth 4 args)))
      ((equal "decrypt" verb) (wank-decrypt-file (ngth 2 args) (nth 3 args) (nth 4 args)))
      ((equal "gen-new-iv" verb) (gen-new-iv))
      (t (usage (nth 0 args))))))