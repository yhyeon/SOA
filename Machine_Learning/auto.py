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
act_set = list(set(acts))
act2idx = { a:i for i, a in enumerate(act_set) }

input_dim = len(act_set)
hidden_size = 128
output_dim = len(act_set)
sequence_length = 6

x_data = []
y_data = []

for i in range(len(acts) - sequence_length):
        x_pattern = acts[i:i+sequence_length]

        x = [ act2idx[a] for a in x_pattern ]

        x_data.append(x)
batch_size = len(x_data)
sample_idx = [ act2idx[a] for a in acts ]
x_one_hot = np.eye(len(act_set))[x_data]

#--------------------------------------------------
X = tf.placeholder(tf.float32, [None, input_dim])

W_encode = tf.Variable(tf.random_normal([input_dim, hidden_size]))
b_encode = tf.Variable(tf.random_normal([hidden_size]))
encoder = tf.nn.sigmoid(tf.add(tf.matmul(X, W_encode), b_encode))

W_decode = tf.Variable(tf.random_normal([hidden_size, input_dim]))
b_decode = tf.Variable(tf.random_normal([input_dim]))
decoder = tf.nn.sigmoid(tf.add(tf.matmul(encoder, W_decode), b_decode))

cost = tf.reduce_mean(tf.pow(X - decoder, 2))
optimizer = tf.train.RMSPropOptimizer(learning_rate = 0.01).minimize(cost)

init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)

training_epoch = 10
for epoch in range(training_epoch):
	total_cost = 0
	
	for i in range(1, len(x_one_hot)):
		_, cost_val = sess.run([optimizer, cost], feed_dict = {X:x_one_hot[i]})
		total_cost += cost_val
	print("Epoch:", '%4d' % (epoch + 1))
	print("Average Cost: %.4f" %(total_cost/(i+1)))

	for i in range(1, len(x_one_hot)):
		samples = sess.run(decoder, feed_dict = {X:x_one_hot[i]})
		print(samples)
		print(x_one_hot[i])
