#include <iostream>

extern "C" int GetSomething();

int main() {
    std::cout << "From assembly:" << GetSomething() << std::endl;
}
