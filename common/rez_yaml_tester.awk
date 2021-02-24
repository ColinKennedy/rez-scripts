BEGIN {
    was_in_test_block=0
    is_in_test_block=0
}

{
    if (was_in_test_block)
    {
        next;
    }

    if ($0 == "tests:")
    {
        is_in_test_block=1;
        next;
    }

    if (is_in_test_block == 1)
    {
        if ($0 ~ /^ /)
        {
            if ($0 ~ "  " + request + ":")
            {
                print $0
            }
        }
        else
        {
            is_in_test_block=0
            was_in_test_block=1
        }
    }
}
