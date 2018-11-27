import pickle
import pyscreenshot as ps
import numpy as np
from skimage import io
import mss
import mss.tools

def to_binary_colors(mat):
    # take top left corner as the "0" color, others as "1"
    target = mat[0]
    bin_mat = [0 if x == target else 1 for x in mat]
    return bin_mat

def get_binary_matrixes(upper_arr, lower_arr):
    upper = to_binary_colors(upper_arr)
    lower = to_binary_colors(lower_arr)
    mat_u = np.array([upper[i*77:(i+1)*77] for i in range(14)])
    mat_l = np.array([lower[i*77:(i+1)*77] for i in range(14)])
    return mat_u, mat_l

def get_number(mat, digits_dict):
    number = 0
    # slide 6 pixel wide window over matrix, matching for digits
    for x in range(mat.shape[1]-6):
        for digit, digit_mat in digits_dict.items():
            if np.array_equal(mat[:, x:x+6], digit_mat):
                number += digit
                number *= 10
                break

    return number // 10

if __name__ == "__main__":
    # digits to (14, 7) matrix map
    digits_dict = pickle.load(open('digits.p', 'rb'))
    # bboxes needs to have shape (14, 77)
    # upper bbox coordinates
    u_x1, u_y1 = (967, 342)
    u_x2, u_y2 = (1044, 356)
    # lower bbox coordinates
    l_x1, l_y1 = (967, 523)
    l_x2, l_y2 = (1044, 537)

    with mss.mss() as sct:
        upper_ss = sct.grab((u_x1, u_y1, u_x2, u_y2))
        lower_ss = sct.grab((l_x1, l_y1, l_x2, l_y2))

    # reads bytes as flat array
    upper_barr = np.frombuffer(upper_ss.raw, dtype='uint32')
    lower_barr = np.frombuffer(lower_ss.raw, dtype='uint32')
    
    # convert to binary valued matrixes of shape (14, 77)
    sell_image, buy_image = get_binary_matrixes(upper_barr, lower_barr)

    sell_price = get_number(sell_image, digits_dict)
    buy_price = get_number(buy_image, digits_dict)

    print('sell price: {}\nbuy price: {}'.format(sell_price, buy_price))
    
