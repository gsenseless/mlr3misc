context("map_values")

test_that("map_values", {
  x = letters[1:5]
  old = c("b", "d", "z")
  new = c("x", "y", "1")
  expect_equal(map_values(x, old, new), c("a", "x", "c", "y", "e"))

  old = c("m")
  new = c("n")
  expect_equal(map_values(x, old, new), x)

  old = c("a", "b")
  new = "z"
  expect_equal(map_values(x, old, new), c("z", "z", "c", "d", "e"))
})
