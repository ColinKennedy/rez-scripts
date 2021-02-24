function parse_requirement(text)
{
    sub(/^    - /, "", text)

    return text
}


function get_requirements(result)
{
    requirements_found = 0
    current_count = 0

    while (1)
    {
        if (requirements_found && $0 ~ "^\\s+-")
        {
            result[current_count] = parse_requirement($0)
            current_count += 1
        }

        if ($0 ~ "^    requires:")
        {
            requirements_found=1
            getline

            continue
        }

        if ($0 ~ "^  \\w+")
        {
            # We've reached the end of the test definition
            return
        }

        getline
    }
}

BEGIN {
    was_in_test_block = 0
    is_in_test_block = 0
}

{
    if (was_in_test_block)
    {
        next;
    }

    if ($0 == "tests:")
    {
        is_in_test_block = 1;
        next;
    }

    if (is_in_test_block == 1)
    {
        if ($0 ~ /^ /)
        {
            if ($0 ~ "^  blac.*:$")
            {
                getline
                split("", result)
                get_requirements(result)

                for (requirement in result)
                {
                    print result[requirement]
                }
            }
        }
        else
        {
            is_in_test_block = 0
            was_in_test_block = 1
        }
    }
}
