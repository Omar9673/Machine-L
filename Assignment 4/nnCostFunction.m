function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

% %Cost function without regularization:
% h1 = sigmoid([ones(m, 1) X] * Theta1');
% h2 = sigmoid([ones(m, 1) h1] * Theta2'); %taken from predict.m
% for k=1:1:num_labels
%     labels= y==k; %For example, y(1)=1 and the rest of y = 0 
%     h= h2(:,k);
%     J=J+(-1/(m))*(labels'*log(h)+(1-labels)'*(log(1-h))); %Cost without Regularization.
%     
% %Cost function with regularization:
% Theta1NoBias= Theta1(:,2:end);
% Theta2NoBias= Theta2(:,2:end); %Taking thetas without bias bec we don't want to regularize bias.
% ThetaNoBias= [Theta1NoBias(:);Theta2NoBias(:)];
% J=J+lambda/(2*m)*sum(ThetaNoBias.^2); %Cost function with regularization.

%Cost function without regularization:
h1= sigmoid([ones(m, 1) X] * Theta1');
h2= sigmoid([ones(m, 1) h1] * Theta2'); %taken from predict.m
for k= 1:1:num_labels
    labels= y==k; %For example, y(1)=1 and the rest of y = 0
    h= h2(:,k);
    J= J+(-1/(m))*(labels'*log(h)+(1-labels)'*(log(1-h))); %Cost without Regularization
end
%Cost function with regularization:
Theta1NoBias = Theta1(:,2:end); 
Theta2NoBias = Theta2(:,2:end);  %Taking thetas without bias bec we don't want to regularize bias.
J = J+(lambda/(2*m)*sum([Theta1NoBias(:).^2; Theta2NoBias(:).^2])); %Cost function with regularization.
    
    
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
for t = 1:m
    a1= X(t,:)';
    a1= [1;a1];
    z2= Theta1*a1;
    a2= sigmoid(z2);
    a2= [1;a2];
    z3= Theta2*a2;
    a3= sigmoid(z3);
    labels= y(t)==(1:num_labels)';
    delta3k= a3-labels;
    delta2k= Theta2(:,2:end)'*delta3k.*sigmoidGradient(z2);
    Theta2_grad = Theta2_grad+delta3k*a2';
    Theta1_grad = Theta1_grad+delta2k*a1';
    
    
    
end
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Theta1_grad = (Theta1_grad+lambda*[zeros(hidden_layer_size,1) Theta1(:,2:end)])/m;
Theta2_grad = (Theta2_grad+lambda*[zeros(num_labels,1) Theta2(:,2:end)])/m;
% Theta1_grad = Theta1_grad/m;
% Theta2_grad = Theta2_grad/m;


















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
