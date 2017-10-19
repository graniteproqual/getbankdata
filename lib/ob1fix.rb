class Ob1fix
  def f(s,k)
    g(s.gsub!(g(k), ''))
  end
  def g(s)
    r = ''
    s.each_byte {|c| r<<(c-1).chr
    puts c}
    r
  end
end

