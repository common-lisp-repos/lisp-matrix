;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;; TODO: wrap this in a #+(or <supported-systems>) with an error if 
;;; the system isn't supported.
;;;
(in-package :cl-user)

(defpackage :lisp-matrix-asd
  (:use :cl :asdf))

(in-package :lisp-matrix-asd)

(defsystem lisp-matrix
    :name "lisp-matrix"
    :version "0.0.1"
    :author "Mark Hoemmen <mhoemmen@cs.berkeley.edu>"
    :license "BSD sans advertising clause"
    :description "linear algebra library"
    :long-description "Linear algebra library for ANSI Common Lisp;
    implemented at the lowest level using CFFI to call the BLAS and
    LAPACK.  Should run on any ANSI CL implementation that supports
    CFFI.  Also considers lisp-centric and foreign-centric storage, in
    a manner friendly to the other storage facility."
    :serial t
    :depends-on (:cffi
		 :cl-utilities

                 ;; :fiveam  ;;see below for its replacement...
		 :lift ;; yes, Tony (me) is a PITA...
		 :org.middleangle.foreign-numeric-vector
		 :org.middleangle.cl-blapack
		 :ffa)
    :components
    ((:module
      "package-init"
      :pathname #p "src/"
      :components
      ((:file "package")))

     (:module
      "basics"
      :pathname #p"src/"
      :depends-on ("package-init") 
      :components
      ((:file "utils"  )
       (:file "macros" )
       (:file "matrix" )
       (:file "vector" :depends-on ("matrix"))
       (:file "matrix-implementations" :depends-on ("matrix" "vector"))))

     (:module
      "implementations"
      :pathname #p"src/"
      :depends-on ("package-init" "basics")
      :components
      ((:file "matrix-lisp-array")
       (:file "matrix-foreign-array")
       (:file "lapack-utils" :depends-on ("matrix-foreign-array"
					  "matrix-lisp-array"))
       (:file "lapack-methods" :depends-on ("lapack-utils"))
       (:file "matrix-operations" :depends-on ("lapack-methods"))))

     (:module
      "testing"
      :pathname #p "src/unittests/"
      :depends-on ("implementations")
      :components
      ((:file "unittests"))))
       ;; (:file "tests")
;;     :in-order-to ((test-op (load-op lisp-matrix)))
;;     :perform (test-op :after (op c)
;;                       (funcall (intern "RUN!" 'fiveam)
;;                                (intern "TESTS" 'lisp-matrix)))
    )

;;;; keep ASDF thinking that the test operation hasn't been done
;; (defmethod operation-done-p 
;;            ((o test-op)
;;             (c (eql (find-system 'lisp-matrix))))
;;   (values nil))
