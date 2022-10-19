(require "asdf")

(let ((asdf:*user-cache* (uiop:getenv "AUTOPKGTEST_TMP"))) ; Store FASL in some temporary dir
  (asdf:load-system "trivial-gray-streams-test"))

(let ((failed-tests (trivial-gray-streams-test:failed-test-names (trivial-gray-streams-test:run-tests))))
  ;; Filter out some expected failures (as of 2018-03-24)
  (setq failed-tests (delete "stream-advance-to-column" failed-tests
                             :test #'string=))
  #+clisp
  (setq failed-tests (nset-difference failed-tests
                                      '("stream-start-line-p" "stream-write-string"
                                        "stream-terpri" "stream-fresh-line")
                                      :test #'string=))

  (unless (null failed-tests)
    (format t "The following test(s) failed: ~{~A~^ ~}" failed-tests)
    (uiop:quit 1)))
