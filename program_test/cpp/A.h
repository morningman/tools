#ifndef A_H
#define A_H

#include <string>

class A {
private:
    std::string str;

public:
    A(const std::string& s);
    std::string getString() const;
};

#endif 