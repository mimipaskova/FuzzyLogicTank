
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


var malkoRazst = [50,150,250];
var srednoRazst = [150,300,450];
var myNumber = 200;
// console.log(calculateM(myNumber, srednoRazst));
// console.log(calculateM(myNumber, malkoRazst));

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

var znamenatel = 0;


function checkDistances(givenDistance) {
    var distancesTurnOn = Object.keys(distance).filter(dist => {
//         console.log(givenDistance, dist, distance[dist][0]);
        return (distance[dist][0] < givenDistance && givenDistance < distance[dist][2]);
    });
    return distancesTurnOn;
}


function fuzzification(givenDistance) {
    var ms = Object.keys(distance).map(dist => {
        console.log(givenDistance, dist, distance[dist]);
        return {[dist] : calculateM(givenDistance, distance[dist])};
    });
    return ms;
}

function calculateZ(givenDistance) {
    return fuzzification(givenDistance).map(dist => {
//         return speed[rules[Object.keys(dist)]] + ' ' + Object.values(dist)
        console.log(dist);
        return blah(Object.values(dist), speed[rules[Object.keys(dist)]]);
    });
}

function blah (alfaI, triangleVariable) {
//     var sum = 0;
//     for(var i = triangleVariable[0]; i < triangleVariable[2]; i +=100) {
//         sum += Math.abs(i * calculateM(alfaI, triangleVariable));
//         console.log(sum);
//     }
//     return sum;
    
    var sum = 0;
    console.log(alfaI, triangleVariable);
    if(alfaI > 0) {
        for(var i = triangleVariable[0]; i < triangleVariable[2]; i +=100) {
            znamenatel += Math.min(calculateM(i, triangleVariable), alfaI);
            console.log(i, calculateM(i, triangleVariable));
            sum += i * Math.min(calculateM(i, triangleVariable), alfaI);
// 		  console.log(sum, alfaI);
        }    
        sum = sum;
    }    
    return sum;
}

function output(givenDistance) {
    znamenatel = 0;
    return calculateZ(givenDistance).reduce((a, b) => a + b, 0)/znamenatel;
}






function values(givenDistance) {
    var ms = Object.keys(distance).map(dist => {
        //console.log(givenDistance, dist, distance[dist]);
        return calculateM(givenDistance, distance[dist]);
    });
    return ms;
}

function getAlfaCut(givenDistance) {
    return Math.max(...values(givenDistance));
}

// console.log(fuzzification(200));
//console.log(getAlfaCut(200))
