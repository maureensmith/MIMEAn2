//
// Created by Smith, Maureen on 06.01.21.
//

#ifndef MIMEAN2_PARAMETER_HPP
#define MIMEAN2_PARAMETER_HPP

#include <string_view>
namespace parameter {

    /**
     * Contains all relevant parameters and thresholds for the computation and filtering of the Kd values and directories
     * for reading the input data and storing the results
     */
    struct Parameter {

        //coeffcient threshold at what a warning is given that the data looks strange
        const double coeffThreshold = 100.0;

        //significant if log2(Kd) is X fold higher/lower than the threshold
        double significanceThreshold = 0;

        //if estimated errors differ too much they can also be corrected separately
        bool joinErrors = true;

    // 		int cutValueFwd = 30;
        int cutValueFwd = 0;
        int cutValueBwd = 0;
        int seqBegin = cutValueFwd+1;
        int seqEnd;

        //threshold of minimum read coverage (enough signal)
        double weightThreshold = 0.5;
        int minimumNrCalls = 100000;


        //parameter for result and plot options
        double minSignal2NoiseStrength = 2;
        double alpha = 0.05;
        int minNumberEstimatableKDs = 50;
        //minimum mutation rate (10^-minMutRate)
        double minMutRate = 4.0;

        std::string_view ref_file;
        std::string_view data_dir;
        std::string_view result_dir;


        Parameter(std::string_view parameter_file_sw) {
            readParameterFile(parameter_file_sw);
        };

    private:
        /**
        * read and parse given input file
        */
        void readParameterFile(const std::string_view file_sw);



    };
}


#endif //MIMEAN2_PARAMETER_HPP
