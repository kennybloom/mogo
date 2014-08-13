class String
  def to_num3
    (self + "\0").to_num4
  end

  def to_num4
    self.unpack('V*')[0]
  end
end

class CNIP
  class IPLocation
    attr_accessor :country, :area

    def initialize(c = nil, a = nil)
      @country = c
      @aera = a
    end
  end # IPLocation

  VERSION = '0.1a'

  REDIRECT_MODE_1 = 1
  REDIRECT_MODE_2 = 2

  def initialize(dbfilepath)
    @dbfilepath = dbfilepath
    #Todo: check db file
    @dbfile = File.open(dbfilepath, 'rb')
    @index_first = @dbfile.read(4).to_num4
    @index_last = @dbfile.read(4).to_num4
    
    @area_unknow = 'UNKNOW_AREA'
  end

  def dbVersion
    ip, pos = getRecord(@index_last)
    loc = getIPLocation(pos+4)
    return loc.country + ' ' + loc.area
  end

  def where(strIP)
    #Todo: check IP format
    pos = searchIP(strIP)
    return nil if pos == 0
    return getIPLocation(pos)
  end

  private
  def searchIP(strIP)
    ips = 0
    strIP.split('.').each do |i|
      ips <<= 8
      ips += i.to_i
    end
    sumRec = (@index_last - @index_first).div(7) + 1
    recHead = 0
    recEnd = sumRec
    ipBegin = ipENd = 0
    begin
      middle = (recHead + recEnd).div(2)
      @dbfile.pos = @index_first + 7*middle
      ipBegin = @dbfile.read(4).to_num4
      if ipBegin>ips
        recEnd = middle
        next
      end

      @dbfile.pos = @dbfile.read(3).to_num3
      ipEnd = @dbfile.read(4).to_num4
      if ipEnd<ips
        return(0) if middle == recHead
        recHead = middle
      end
    end until not (ipBegin>ips || ipEnd<ips)
    return @dbfile.pos
  end

  def getRecord(offset)
    @dbfile.pos = offset
    ip = @dbfile.read(4).to_num4
    pos = @dbfile.read(3).to_num3
    return [ip, pos]
  end

  def getIPLocation(offset)
    @dbfile.pos = offset
    loc = IPLocation.new()
    case @dbfile.getc()
    when REDIRECT_MODE_1
      countryOffset = @dbfile.read(3).to_num3
      @dbfile.pos = countryOffset
      if @dbfile.getc() == REDIRECT_MODE_2
        loc.country = readString(@dbfile.read(3).to_num3)
        @dbfile.pos = countryOffset + 4
      else
        loc.country = readString(countryOffset)
      end
      loc.area = readArea(@dbfile.pos)
    when REDIRECT_MODE_2
      loc.country = readString(@dbfile.read(3).to_num3)
      loc.area = readArea(offset + 8)
    else
      loc.country = readString(@dbfile.pos - 1)
      loc.area = readArea(@dbfile.pos)
    end
    return(loc)
  end

  def readArea(offset)
    @dbfile.pos = offset
    b = @dbfile.getc()
    if b == REDIRECT_MODE_1 || b == REDIRECT_MODE_2
      areaOffset = @dbfile.read(3).to_num3
      if areaOffset == 0
        return @area_unknow
      else
        return readString(areaOffset)
      end
    else
      return readString(offset)
    end
  end

  def readString(offset)
    @dbfile.pos = offset
    c = nil
    r = ''
    begin
      c = @dbfile.read(1)
      r += c
    end until c == "\0"
    return(r.chop)
  end

end

def main()
  ci = CNIP.new('.\QQWry.Dat')
  printf("DB File Version: %s\n", ci.dbVersion)
  hn = 'www.163.com'
  hn = ARGV[0] if ARGV[0]
  require 'resolv'
  ip = Resolv.getaddress(hn)
  loc = ci.where(ip)
  printf("%s:\n  IP: %s\n  Location: %s\n", hn, ip, loc.country + ' ' + loc.area)
end

