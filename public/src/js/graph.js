google.load('visualization', '1.0', {'packages':['corechart']});
var Graph = function(selector, data, kind) {
  this.selector = selector;
  this.data = data;
  this.kind = kind;
};

var instantiateGraphs = function() {
  Graph.instances.forEach(function(instance) {
    instance.render();
  });
}

Graph.prototype.getData = function() {

  var _this = this;

  // create the data table
  var dataWithCaptions = this.data.data.map(function(element, index, array){
    return [ _this.data.x_axis.series[index], element];
  }); 
    
    return google.visualization.arrayToDataTable([
      [ this.data.x_axis.legend, this.data.y_axis.legend ],
    ].concat(dataWithCaptions));

    return data;
}

Graph.prototype.getKind = function(){
  
  var kinds = {
    "column" : "ColumnChart",
    "pie" : "PieChart"
  };

  return kinds[this.kind];

}

Graph.prototype.render = function() {
    // Set chart options
    var options = {'title': this.data.title,
                   'width':400,
                   'height':300,
                   'colors': ['#A2C180','#3D7930','#FFC6A5','#FFFF42','#DEF3BD','#00A5C6','#DEBDDE','#000000'] };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization[this.getKind()]($(this.selector)[0]);
    chart.draw(this.getData(), options);
};


Graph.instances = [];