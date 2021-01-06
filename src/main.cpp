#include <iostream>
#include <filesystem>
#include "Parameter.hpp"

int main(int argc, char** argv) {

    // check if enough parameter given
    if(argc < 2 && argc > 3 || argv[1] == "-h" || argv[1] == "--help") {
        std::cout << "MIMEAn2 has to be called with at least two paramters: \n\n"
                     "MIMEAn2 parameterFile <filename_suffix>\n\n"
                     "The first mandatory parameter is the parameter.json file. The parent directory is used as result directory.\n"
                     //"the first mandatory parameter for result directory (which contains the needed parameter.json file)\n"
                     "The second optional parameter is a suffix for the result tables." << std::endl;

        return 1;
    }

    std::string_view param_file_sw{argv[1]};

    // file name suffix to add to the saved plots and tables
    std::string_view filename_suffix_sw{""};
    if(argc == 3) {
        filename_suffix_sw = argv[2];
    }

    //Read parameters
    parameter::Parameter parameter{param_file_sw};


    //remove tmp files from previous run
    //if(ioTools::dirExists(parameter.resultDir))
    //    ioTools::removeTmpFiles(parameter.resultDir);



    //load the sample data



    //Calculate error

    //Calculate raw Kd

    //apply quality filter

    //write output tables

    return 0;
}
