context("grattan tests")

context("FY")

fy.year <- .yr2fy

test_that("is_fy() returns TRUE on FYs", {
  expect_true(is_fy("2012-13"))
  expect_true(is_fy("1999-00"))
  expect_true(is_fy("201415"))
})

test_that("is_fy() returns FALSE on non-FYs", {
  expect_false(is_fy("2012-14"))
  expect_false(is_fy("banana"))
  expect_false(is_fy("2012-13 was a long year"))
  expect_false(is_fy("20121313"))
  expect_false(is_fy("12-13"))
})

test_that("Other fy utils", {
  expect_equal(fy.year(2012), "2011-12", check.attributes = FALSE)
  # Not an FY
  expect_error(fy2yr("2014-16"))
  expect_error(fy2date("2014-16"))

  expect_equal(fy2date("2012-13"), as.Date("2013-06-30"))
})

test_that("all_fy", {
  expect_true(all_fy(c("2000-01", "2010-11", "2013-14", "2020-21")))
  expect_true(all_fy(c("2000-01", "2010-11", "2013-14", "2020-21"),
                     permitted = c("2000-01", "2010-11", "2013-14", "2020-21")))
})

test_that("is_fy2", {
  expect_true(all(is_fy2(c("2000-01", "2010-11", "2013-14", "2020-21"))))
})

test_that("Correct logic when asserting fys", {
  # Previous to October 2019, 'fy.yr contains non-FYs'
  # This was dropped because it was wrong (`fy.yr` wasn't
  # even the argument) and not as descriptive.
  expect_error(fy2date(c("foo", "2015-16")),
               regexp = 'contained "foo" which is not a valid financial year.',
               fixed = TRUE)
  expect_error(fy2yr(c("foo", "2015-16")),
               regexp = 'contained "foo" which is not a valid financial year.',
               fixed = TRUE)
})

test_that("fy.year and yr2fy are identical", {
  x <- 1901:2099
  expect_identical(fy.year(x), yr2fy(x))
})

test_that("grattan.assume1901_2100 options", {
  skip_if_not_installed("rlang")
  skip_on_cran()
  x <- 1900:2099
  rlang::with_options(
    expect_identical(fy.year(x), yr2fy(x)),
    grattan.assume1901_2100 = FALSE
  )
  expect_identical(fy.year(x), yr2fy(x, FALSE))
})

test_that("yr2fy and .yr2fy", {
  x <- 1900:2100
  expect_identical(fy.year(x), .yr2fy(x))
  x <- rep_len(x, 20e3)
  expect_identical(fy.year(x), .yr2fy(x))
})

test_that("range_fy", {
  expect_identical(max_fy2yr(c("2015-16", "2000-01", "2001-02")), 2016L)
  expect_identical(min_fy2yr(c("2015-16", "2000-01", "2001-02")), 2001L)
})

test_that("qtr2fy", {
  skip_if_not_installed("zoo")
  library(zoo)
  expect_equal(qtr2fy(as.yearqtr("2014 Q2")), "2013-14", check.attributes = FALSE)
  expect_equal(qtr2fy(as.yearqtr(c("2014 Q2", "2014 Q3",
                                   "2014 Q1", "2013 Q4"))),
               c("2013-14", "2014-15",
                 "2013-14", "2013-14"),
               check.attributes = FALSE)

  expect_equal(qtr2fy("2014-Q2"), "2013-14", check.attributes = FALSE)
  expect_equal(qtr2fy(c("2014-Q2", "2014-Q3",
                        "2014-Q1", "2013-Q4")),
               c("2013-14", "2014-15",
                 "2013-14", "2013-14"),
               check.attributes = FALSE)
})

test_that("NA handling", {
  expect_equal(qtr2fy(c("2014-Q1", NA, "2014-Q2")),
               c("2013-14", NA, "2013-14"))
  expect_equal(qtr2fy(c(NA, "2014-Q1", "2014-Q2")),
               c(NA, "2013-14", "2013-14"))
})

test_that("qtr2fy error", {
  expect_error(qtr2fy(raw(1)))
})





