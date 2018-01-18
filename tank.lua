rules = {
    vshort = 'negative',
    short = 'low',
    medium = 'medium',
    large = 'high'
}

distance = {
    vshort = {0, 50, 100},
    short = {50, 150, 250},
    medium = {150, 300, 450},
    large = {400, 500, 500}
};

speed = {
    negative = {-2000, -1000, 0},
    low = {-400, 0, 400},
    medium = {300,500,700},
    high = {500, 1000,1500}
};

alfaSum = 0;

print(distance.vshort[4])
print(speed.medium[2])
print(alfaSum)
print(rules.large)
