(ql:quickload 'ironclad)
(in-package :jcrypt)

(defun slurp-file (file)
  (with-open-file (in file :direction :input :element-type '(unsigned-byte 8))
    (let ((seq (make-array (file-length in) :element-type (stream-element-type in))))
      (read-sequence seq in)
      seq)))

(defvar *iv*
  (make-array 16 :element-type '(unsigned-byte 8)
	      :initial-contents '(21 130 211 125 115 2 235 232 105 65 212 144 205 197 94 170)))

(defun gen-new-iv ()
  (with-open-file (out "~/.jcrypt.iv" :direction :output :if-does-not-exist :create :element-type '(unsigned-byte 8))
    (write-sequence (ironclad:random-data 16 (ironclad:make-prng :fortuna)) out)))

(defun read-iv ()
  (slurp-file "~/.jcrypt.iv"))

(defun encrypt-file (file pass out)
  ;;(declare (optimize (speed 3) (safety 3) (space 0) ))

  (let* ((data (slurp-file file))
	 (key (ironclad:ascii-string-to-byte-array pass))
	 (cipher (ironclad:make-cipher 'ironclad:rc6
				       :initialization-vector *iv*
				       :key key
				       :mode 'ironclad:cfb)))
    (ironclad:encrypt-in-place cipher data)
    (write-sequence data out)))

(defun wank-encrypt-file (infile key outfile)
  (with-open-file (out outfile :direction :output :if-exists :supersede
		       :element-type '(unsigned-byte 8))
    (encrypt-file infile key out)))

(defun decrypt-file (file pass out)
  (let* ((data (slurp-file file))
	 (key (ironclad:ascii-string-to-byte-array pass))
	 (cipher (ironclad:make-cipher 'ironclad:rc6
				       :initialization-vector *iv*
				       :key key
				       :mode 'ironclad:cfb)))
    (ironclad:decrypt-in-place cipher data)
    (write-sequence data out)))

(defun wank-decrypt-file (infile key outfile)
  (with-open-file (out outfile :direction :output :if-exists :supersede
		       :element-type '(unsigned-byte 8))
    (decrypt-file infile key out)))
