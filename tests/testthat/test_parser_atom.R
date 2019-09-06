source("helper_data.R")

test_that("Test that atom feeds can be recognised", {
  expect_equal(xml_attr(atom, "xmlns"), "http://www.w3.org/2005/Atom")
  expect_equal(xml_ns(atom)[[1]], "http://www.w3.org/2005/Atom")
  expect_equal(xml_attr(atom_real, "xmlns"), "http://www.w3.org/2005/Atom")
  expect_equal(xml_ns(atom_real)[[1]], "http://www.w3.org/2005/Atom")
})
test_that("Test that correct number of entries are found", {
  expect_equal(
    xml_find_all(atom, "atom:entry", ns = ns) %>% length(), 1
    )
  expect_equal(
    xml_find_all(atom_real, "atom:entry", ns = ns_r) %>% length(), 2
  )
})
test_that("Correct number of title fields are found", {
  expect_equal(
    xml_find_all(atom_null, ns = ns_n, "atom:title") %>% length(), 1
  )
  expect_equal(
    xml_find_all(atom_empty, ns = ns_e, "atom:title") %>% length(), 0
  )
  expect_equal(
    xml_find_all(atom_real, ns = ns_r, "atom:title") %>% length(), 1
  )
  expect_equal(
    xml_find_all(atom, ns = ns, "atom:title") %>% length(), 1
  )
})
# test_that("Correct link is found")

