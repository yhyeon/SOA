import tensorflow as tf
import numpy as np

logs = open("sample.txt", 'r')

acts = []
for line in logs:
	line = line.strip("\n")
	line = line.strip(",")
	l = line.split(",")

	for i in l:
		acts.append(i)
print(acts)

act_set = list(set(acts))
act2idx = { a:i for i, a in enumerate(act_set) }

print(act2idx)

input_dim = len(act_set)
hidden_size = len(act_set)
ouput_dim = len(act_set)
sequence_length = 7

x_data = []
y_data = []

for i in range(len(acts) - sequence_length):
	x_pattern = acts[i:i+sequence_length]
	y_pattern = acts[i+1:i+sequence_length+1]

	x = [ act2idx[a] for a in x_pattern ]
	y = [ act2idx[a] for a in y_pattern ]
	
	x_data.append(x)
	y_data.append(y)

batch_size = len(x_data)

sample_idx = [ act2idx[a] for a in acts ]

print("sample_idx:", sample_idx)

X = tf.placeholder(tf.int32, [None, sequence_length])
Y = tf.placeholder(tf.int32, [None, sequence_length])

x_one_hot = tf.one_hot(X, input_dim)

cell = tf.contrib.rnn.BasicLSTMCell(num_units = input_dim, state_is_tuple = True)
initial_state_ = cell.zero_state(batch_size, tf.float32)
outputs, _states = tf.nn.dynamic_rnn(cell, x_one_hot, initial_state = initial_state_, dtype = tf.float32)

#---------------------SoftMax-------------------------#
x_for_softmax = tf.reshape(outputs, [-1, hidden_size])

softmax_w = tf.get_variable("softmax_w", [hidden_size, input_dim])
softmax_b = tf.get_variable("softmax_b", [input_dim])

outputs = tf.matmul(x_for_softmax, softmax_w) + softmax_b
outputs = tf.reshape(outputs, [batch_size, sequence_length, input_dim])
#---------------------SoftMax-------------------------#

weights_ = tf.ones([batch_size, sequence_length])
sequence_loss = tf.contrib.seq2seq.sequence_loss(logits = outputs, targets = Y, weights = weights_)
loss = tf.reduce_mean(sequence_loss)
train = tf.train.AdamOptimizer(learning_rate=0.1).minimize(loss)


original_a = ""
predict_a = ""
with tf.Session() as sess:
	sess.run(tf.global_variables_initializer())
	for i in range(500):
		_, loss_, results = sess.run([train, loss, outputs], feed_dict = { X:x_data, Y:y_data})
		print(results)
		for j, result in enumerate(results):
			index = np.argmax(result, axis = 1)
			print(i, "%2d" %j, ''.join([act_set[t] for t in index]), loss_)
			if j is 0:
				for k, t in enumerate(index):
					if k is 0:
						original_a += acts[k+1]
						predict_a += act_set[t]
					else:
						original_a += '-' + acts[k+1]
						predict_a += '-' + act_set[t]
			else:
				original_a += '-' + acts[j+k+1]
				predict_a += '-' + act_set[index[-1]]
		print("original:", original_a)
		print("predict:", predict_a)
		predict_a = ""
		original_a = ""
