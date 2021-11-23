/*----------------------------------------------------------------------------
 * Name:    main.c
 *----------------------------------------------------------------------------*/

#include "unity.h"
#include <stdio.h>

// In my_sum.c
static int my_sum(int a, int b) {
  return a + b;
}

void setUp(void) {
  // set stuff up here
}

void tearDown(void) {
  // clean stuff up here
}

static void test_my_sum_pos(void) {
  const int sum = my_sum(1, 1);
  TEST_ASSERT_EQUAL_INT(2, sum);
}

static void test_my_sum_neg(void) {
  const int sum = my_sum(-1, -1);
  TEST_ASSERT_EQUAL_INT(-2, sum);
}

static void test_my_sum_zero(void) {
  const int sum = my_sum(0, 0);
  TEST_ASSERT_EQUAL_INT(0, sum);
}

static void test_my_sum_fail(void) {
  const int sum = my_sum(1, -1);
  TEST_ASSERT_EQUAL_INT(2, sum);
}

int main(void) {
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
