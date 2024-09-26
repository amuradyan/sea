Doing `Kernel.inspect` for logging for every evaluation and closure application for logging was the reason for unbareably slow execution.

After removing them, running the single test for `sandbox.sea` went down to 0.07s from some 214s.

`eprof` results of evaluation of the [`sandbox.sea`](../seac/test/fixtures/sandbox.sea) with logs:

    SUBJECT                                                          CALLS     %      TIME µS/CALL

    Total                                                        451401364 100.0 104911109    0.23
    ...
    SeaC.Evaluator.apply_closure/3                                     101  0.00      4660   46.14 ***
    :logger_config.get/3                                              6171  0.00      4683    0.76
    :logger.add_default_metadata/2                                    8228  0.00      4992    0.61
    ...
    Kernel.inspect/2                                                  4114  0.00     47808   11.62 *
    SeaC.Evaluator.meaning/2                                           978  0.01     56268   57.53 ****
    :logger.tid/0                                                     2057  0.01     59713   29.03 **
    String.Tokenizer.unicode_start/1                               1953084  0.03    272614    0.14
    ...


`eprof` results of evaluation of the [`sandbox.sea`](../seac/test/fixtures/sandbox.sea) without logs:

    SUBJECT                                                 CALLS     % TIME µS/CALL

    Total                                                   92671 100.0 1122    0.12

    SeaC.Evaluator.apply_closure/3                            101  0.23   26    0.26
    anonymous fn/2 in SeaC.Evaluator.atom_to_action/1         391  0.24   27    0.07
    ...
    SeaC.Evaluator.meaning/2                                  978  1.10  124    0.13
    :unicode.characters_to_binary/2                           566  1.13  127    0.22

The `inspect` and `logger` are gone. I needed it for pretty printing tbh, probably can find a better way to do that.
