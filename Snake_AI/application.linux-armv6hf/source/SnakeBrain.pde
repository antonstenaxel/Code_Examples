class SnakeBrain {
  float[][] inputWeights;
  float[][] hiddenWeights;
  float[][] outputWeights;


  SnakeBrain() {
    this.inputWeights = randomMatrix(39,20,-0.1,0.1);
    this.hiddenWeights = randomMatrix(20,20,-0.1,0.1);
    this.outputWeights = randomMatrix(20,1,-0.1,0.1);
  }


SnakeBrain(float[][] inputWeights, float[][] hiddenWeights, float[][] outputWeights){
  this.inputWeights=inputWeights;
  this.hiddenWeights = hiddenWeights;
  this.outputWeights = outputWeights;

}
  float[][] process(float[][] input) {
    float[][] interim = feedForward(input, inputWeights);
    interim = feedForward(interim,hiddenWeights);
    return feedForward(interim, outputWeights);
  }

  float[][] feedForward(float[][] input, float[][] weights) {
    return sigmoid(multiply(input, weights));
  }


  float[][] randomMatrix(int n, int m, float min, float max) {

    float[][] matrix = new float[n][m];

    for (int i = 0; i< n; i++) {
      for (int j = 0; j< m; j++) {
        matrix[i][j] = min + (max-min)*random(1);
      }
    }
    
    return matrix;
  }

  float[][] multiply(float[][] a, float[][] b) {

    float[][] result = new float[a.length][b[0].length];
    for (int col=0; col <b[0].length; col++) {
      for (int row=0; row< a.length; row++) {
        for (int k = 0; k< a[0].length; k++ ) {
          result[row][col] = result[row][col] + a[row][k]*b[k][col];
        }
      }
    }
    return result;
  }

  void printMatrix(float[][] matrix) {

    int n=matrix.length;
    int m= matrix[0].length;

    for (int row=0; row< n; row++) {
      for (int col=0; col <m; col++) {
        print(matrix[row][col]+",");
      }
      println();
    }
  }

  float[][] sigmoid(float[][] input) {
    float[][] output = new float[input.length][input[0].length];
    float c=1;
    for (int i=0; i<input.length; i++) {
      for (int j=0; j<input[0].length; j++) {
        output[i][j] = 1/(1+exp(-c*input[i][j]));
      }
    }
    return output;
  }
}