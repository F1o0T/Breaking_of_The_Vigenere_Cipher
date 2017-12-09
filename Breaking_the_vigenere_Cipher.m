cipher_text = "F96DE8C227A259C87EE1DA2AED57C93FE5DA36ED4EC87EF2C63AAE5B9A7EFFD673BE4ACF7BE8923CAB1ECE7AF2DA3DA44FCF7AE29235A24C963FF0DF3CA3599A70E5DA36BF1ECE77F8DC34BE129A6CF4D126BF5B9A7CFEDF3EB850D37CF0C63AA2509A76FF9227A55B9A6FE3D720A850D97AB1DD35ED5FCE6BF0D138A84CC931B1F121B44ECE70F6C032BD56C33FF9D320ED5CDF7AFF9226BE5BDE3FF7DD21ED56CF71F5C036A94D963FF8D473A351CE3FE5DA3CB84DDB71F5C17FED51DC3FE8D732BF4D963FF3C727ED4AC87EF5DB27A451D47EFD9230BF47CA6BFEC12ABE4ADF72E29224A84CDF3FF5D720A459D47AF59232A35A9A7AE7D33FB85FCE7AF5923AA31EDB3FF7D33ABF52C33FF0D673A551D93FFCD33DA35BC831B1F43CBF1EDF67F0DF23A15B963FE5DA36ED68D378F4DC36BF5B9A7AFFD121B44ECE76FEDC73BE5DD27AFCD773BA5FC93FE5DA3CB859D26BB1C63CED5CDF3FE2D730B84CDF3FF7DD21ED5ADF7CF0D636BE1EDB79E5D721ED57CE3FE6D320ED57D469F4DC27A85A963FF3C727ED49DF3FFFDD24ED55D470E69E73AC50DE3FE5DA3ABE1EDF67F4C030A44DDF3FF5D73EA250C96BE3D327A84D963FE5DA32B91ED36BB1D132A31ED87AB1D021A255DF71B1C436BF479A7AF0C13AA14794";
total_size_of_cipher_text = sizeof(cipher_text)
size_of_qi_array = 256;
qi = zeros(1,size_of_qi_array);
possible_key_Length = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Expected_length_of_key = 1:total_size_of_cipher_text
    i = Expected_length_of_key*2-1 ; 
    while i <= total_size_of_cipher_text  
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hex_value = [cipher_text(i) cipher_text(i+1)];
        decimal_value = hex2dec(hex_value);
        qi(decimal_value+1) += 1;
        i += 2 * Expected_length_of_key;
     end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sum = 0;
    for i = 1:size_of_qi_array
      qi(i) /= 256;
      qi(i) *= qi(i);
      sum += qi(i);
    end
    if (sum > 1/256)
      possible_key_Length = [possible_key_Length Expected_length_of_key]
      
    end
    qi= zeros(1,size_of_qi_array);
end 
So_i_Expect_The_Key = max(possible_key_Length)
disp('#########################################################################')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
index_1 = 1;
while index_1 <= 13 
  index_2 = index_1;
  stream_cipher = "";
  while index_2 <= total_size_of_cipher_text
    stream_cipher = [ stream_cipher cipher_text(index_2) cipher_text(index_2+1)];
    index_2 += 14;
  end
  size_of_stream_cipher = sizeof(stream_cipher);
  possible_key_part = [];                                                      
  index_3 = 0;
  to_be_chooses_from = [];
  indices = [];
  while index_3 <= 255                                                                    
    candidate_plain_text = zeros(1,26);
    index_4 = 1;
    while index_4 <= size_of_stream_cipher
      hex_value = [ stream_cipher(index_4) stream_cipher(index_4 + 1)];
      dec_value = hex2dec(hex_value);
      temp = bitxor(dec_value,index_3);
      if(temp < 32)  && (temp > 127)
        break;
      elseif (temp >=97) && (temp <= 122)
        candidate_plain_text(temp - 96) += 1; 
      end
      index_4 += 2;
    end
    count = 0;
    for i = 1:26
      if (candidate_plain_text(i) > 0)
        count += 1;
      end
    end 
    if(count == 0)
      index_3 += 1;
      continue
    end 
    sum = 0;
    for i = 1:26
      candidate_plain_text(i) /= 26;
      candidate_plain_text(i) *= candidate_plain_text(i);
      sum += candidate_plain_text(i);
    end
    to_be_chooses_from = [to_be_chooses_from sum];
    indices            = [indices index_3];  
    candidate_plain_text = [];   
    index_3 += 1;
  end
to_be_chooses_from;
len = length(to_be_chooses_from);
Maximum = max(to_be_chooses_from);
for i = 1:len
  if (to_be_chooses_from(i) == Maximum)
    indices(i)    
  end
end
to_be_chooses_from = [];
index_1 +=2  
end  
Hence_The_Real_Key_Is = [ 186 31 145 178 83 205 62 ]
disp('#########################################################################')
plain_text = "";
j = 1;
i = 1;
while (i <= total_size_of_cipher_text)
  hex_value = [ cipher_text(i) cipher_text(i+1) ];
  dec_value = hex2dec(hex_value);
  plain_text_value = bitxor(dec_value , Hence_The_Real_Key_Is(j));
  plain_text = [plain_text char(plain_text_value)];
  j++;
  if(j > 7)
    j = 1;
  end 
  i += 2; 
end  
cipher_text
disp('')
plain_text

                                                                                
                                                                                
