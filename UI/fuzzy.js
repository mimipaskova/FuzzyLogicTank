var rules = {
    vshort: 'negative',
    short : 'low',
    medium: 'medium',
    large: 'high'
}

var distance = {
    vshort: [0, 50, 100],
    short : [50, 150, 250],
    medium: [150, 300, 450],
    large: [400, 500, 500]
};

var speed = {
    negative: [-2000, -1000, 0],
    low : [-400, 0, 400],
    medium: [300,500,700],
    high: [500, 1000,1500]
};

var alfaSum = 0;


function calculateM(x, triangleVariable) {
    var m = 0;
    if(x < triangleVariable[0]) {
        m = 0;
    } else if(triangleVariable[0]  <= x && x <= triangleVariable[1]) {
        m = (x-triangleVariable[0])/(triangleVariable[1] - triangleVariable[0]);
    } else if(triangleVariable[1]  < x && x <= triangleVariable[2]) {
        m = (triangleVariable[2] - x)/(triangleVariable[2] - triangleVariable[1]);
    } else {
        m = 0;
    }
    return m;
}



function fuzzification(givenDistance) {
    var ms = Object.keys(distance).map(dist => {
        return {[dist] : calculateM(givenDistance, distance[dist])};
    });
    return ms;
}

function calculateZi(givenDistance) {
    return fuzzification(givenDistance).map(dist => {
        return calculateAreaAlfaCut(Object.values(dist), speed[rules[Object.keys(dist)]]);
    });
}

function calculateAreaAlfaCut (alfaI, triangleVariable) {    
    var sum = 0;
    if(alfaI > 0) {
        for(var i = triangleVariable[0]; i < triangleVariable[2]; i +=100) {
            alfaSum += Math.min(calculateM(i, triangleVariable), alfaI);
            sum += i * Math.min(calculateM(i, triangleVariable), alfaI);
        }    
    }    
    return sum;
}

function calculateZ(givenDistance) {
    alfaSum = 0;
    return calculateZi(givenDistance).reduce((a, b) => a + b, 0)/alfaSum;
}

function blah() {
    alert('EEEEEEEE');
}

console.log('0', calculateZ(0))
console.log('100', calculateZ(100))
console.log('150', calculateZ(150))
console.log('200', calculateZ(200))
console.log('300', calculateZ(300))
console.log('350', calculateZ(350))
console.log('400', calculateZ(400))
console.log('450', calculateZ(450))
console.log('500', calculateZ(500))