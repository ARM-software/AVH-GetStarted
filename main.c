/*----------------------------------------------------------------------------
 * Name:    main.c
 *----------------------------------------------------------------------------*/

#include "unity.h"
#include <stdio.h>

extern void stdio_init (void);

/* Application function to test */
static int my_sum(int a, int b) {
  return a + b;
}

/*============= UNIT TESTS ============== */

/* Called in RUN_TEST before executing test function */
void setUp(void) {
  // set stuff up here
}

/* Called in RUN_TEST after executing test function */
void tearDown(void) {
  // clean stuff up here
}

/* Testing summation of positive integers */
static void test_my_sum_pos(void) {
  const int sum = my_sum(1, 1);
  TEST_ASSERT_EQUAL_INT(2, sum);
}

/* Testing summation of negative integers */
static void test_my_sum_neg(void) {
  const int sum = my_sum(-1, -1);
  TEST_ASSERT_EQUAL_INT(-2, sum);
}

/* Testing summation of zeros */
static void test_my_sum_zero(void) {
  const int sum = my_sum(0, 0);
  TEST_ASSERT_EQUAL_INT(0, sum);
}

/* Failing test with incorrect summation value */
static void test_my_sum_fail(void) {
  const int sum = my_sum(1, -1);
  TEST_ASSERT_EQUAL_INT(2, sum);
}

/*  Main: Run tests */
int main(void) {
  stdio_init();

  printf("---[ UNITY BEGIN ]---\n");
  UNITY_BEGIN();
  RUN_TEST(test_my_sum_pos);
  RUN_TEST(test_my_sum_neg);
  RUN_TEST(test_my_sum_fail);
  RUN_TEST(test_my_sum_zero);
  const int result = UNITY_END();
  printf("---[ UNITY END ]---\n");
  return result;
}
